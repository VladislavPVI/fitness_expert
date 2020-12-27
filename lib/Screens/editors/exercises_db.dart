import 'package:fit_master/domain/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../service/db_helper.dart';

class ExercisesDB extends StatefulWidget {
  final String title;

  ExercisesDB({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExercisesDBState();
  }
}

class _ExercisesDBState extends State<ExercisesDB> {
  //
  Future<List<Exercise>> exercises;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // TextEditingController timeController = TextEditingController();

  String image = "assets/images/1.jpg";
  String title, description;
  int curUserId, type, time, level;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      exercises = dbHelper.getUserExercise();
      //exercises = dbHelper.getExercise();
    });
  }

  clearName() {
    titleController.text = '';
    descriptionController.text = '';
    // timeController.text = '';
    type = null;
    // level = null;
  }

  validate() {
    if (formKey.currentState.validate() && type != null) {
      formKey.currentState.save();
      if (isUpdating) {
        Exercise e = Exercise(image, title, description, curUserId, type);
        dbHelper.updateExercise(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Exercise e = Exercise(image, title, description, null, type);
        dbHelper.saveExercise(e);
      }
      clearName();
      refreshList();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => title = val,
            ),
            TextFormField(
              minLines: 2,
              maxLines: 5,
              controller: descriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (val) => val.length == 0 ? 'Enter Description' : null,
              onSaved: (val) => description = val,
            ),
            FormField<int>(builder: (FormFieldState<int> state) {
              return InputDecorator(
                  decoration: InputDecoration(
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      hintText: 'Type of exercise',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  isEmpty: type == null,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                          value: type,
                          isDense: true,
                          onChanged: (int newValue) {
                            setState(() {
                              type = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: [
                        DropdownMenuItem(
                          child: Text("In Seconds"),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text("Repeat Times"),
                          value: 1,
                        )
                      ])));
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    color: Color(0xFF035AA6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Text(isUpdating ? 'UPDATE' : 'ADD',
                        style: TextStyle(color: Colors.white)),
                    onPressed: validate),
                RaisedButton(
                  color: Color(0xFF035AA6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Exercise> exercises) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('User Exercises'),
          ),
          DataColumn(
            label: Text(''),
          )
        ],
        rows: exercises
            .map(
              (exercise) => DataRow(cells: [
                DataCell(
                  Text(exercise.title),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = exercise.id;
                      type = exercise.type;
                    });
                    titleController.text = exercise.title;
                    descriptionController.text = exercise.description;
                    // level = exercise.level;
                    // timeController.text = exercise.time.toString();
                  },
                ),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    dbHelper.deleteExercise(exercise.id);
                    refreshList();
                  },
                )),
              ]),
            )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: exercises,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Create Exercise'),
        backgroundColor: Color(0xFF035AA6),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}
