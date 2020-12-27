import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../domain/Workout.dart';
import '../../service/db_helper.dart';

class WorkoutsDB extends StatefulWidget {
  final String title;

  WorkoutsDB({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkoutsDBState();
  }
}

class _WorkoutsDBState extends State<WorkoutsDB> {
  //
  Future<List<Workout>> workouts;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  String image = "assets/images/0.jpg";
  String title, description;
  int curUserId, type, time;
  int level;

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
      workouts = dbHelper.getUserPlans();
      //workouts = dbHelper.getWorkouts();
    });
  }

  clearName() {
    titleController.text = '';
    descriptionController.text = '';
    timeController.text = '';
    level = null;
  }

  validate() {
    if (formKey.currentState.validate() && level != null) {
      formKey.currentState.save();
      if (isUpdating) {
        Workout e = Workout(image, title, description, curUserId, time, level);
        dbHelper.updateWorkout(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Workout e = Workout(image, title, description, null, time, level);
        dbHelper.saveWorkout(e);
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
            TextFormField(
              controller: timeController,
              decoration:
                  new InputDecoration(labelText: 'Input duration in minutes'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (val) => val.length == 0 ? 'Enter Time' : null,
              onSaved: (val) =>
                  time = int.parse(val), // Only numbers can be entered
            ),
            FormField<int>(builder: (FormFieldState<int> state) {
              return InputDecorator(
                  decoration: InputDecoration(
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      hintText: 'Please select level',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  isEmpty: level == null,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                          value: level,
                          isDense: true,
                          onChanged: (int newValue) {
                            setState(() {
                              level = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: [
                        DropdownMenuItem(
                          child: Text("Beginner"),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text("Intermediate"),
                          value: 1,
                        ),
                        DropdownMenuItem(child: Text("Advanced"), value: 2)
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

  SingleChildScrollView dataTable(List<Workout> workouts) {
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
        rows: workouts
            .map(
              (workout) => DataRow(cells: [
                DataCell(
                  Text(workout.title),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = workout.id;
                      level = workout.level;
                    });
                    titleController.text = workout.title;
                    descriptionController.text = workout.description;
                    timeController.text = workout.time.toString();
                    //type = workouts.type;
                  },
                ),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    dbHelper.deleteWorkout(workout.id);
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
        future: workouts,
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
        title: new Text('Create Plan'),
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
