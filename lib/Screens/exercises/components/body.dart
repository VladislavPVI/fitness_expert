import 'package:fit_master/domain/ExerciseTime.dart';
import 'package:fit_master/Screens/exercises/components/exercises_card.dart';
import 'package:fit_master/domain/Workout.dart';
import 'package:fit_master/service/db_helper.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final Workout workout;
  final String token;

  Body({Key key, this.workout, this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState(workout, token);
  }
}

class _DBTestPageState extends State<Body> {
  var dbHelper;
  Future<List<ExerciseTime>> exercises;
  final Workout workout;
  final String token;

  _DBTestPageState(this.workout, this.token);

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      exercises = dbHelper.getExercisesByWorkoutId(workout.id);
    });
  }

  Stack dataWorkouts(List<ExerciseTime> exercises) {
    return Stack(
      children: <Widget>[
        // Our background
        Container(
          margin: EdgeInsets.only(top: 70),
          decoration: BoxDecoration(
            color: Color(0xFFF1EFF1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
        ),
        ListView.builder(
          // here we use our demo procuts list
          itemCount: exercises.length,
          itemBuilder: (context, index) => ExerciseCard(
            itemIndex: index,
            exercise: exercises[index],
            token: token
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          Text(
            '\n' + workout.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ),
          SizedBox(height: 20.0 / 2),
          Expanded(
            child: FutureBuilder(
              future: exercises,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return dataWorkouts(snapshot.data);
                }

                if (null == snapshot.data || snapshot.data.length == 0) {
                  return Text("No Data Found");
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
