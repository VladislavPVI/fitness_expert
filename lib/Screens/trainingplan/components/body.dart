import 'package:fit_master/Screens/exercises/exercises_screen.dart';
import 'package:fit_master/Screens/trainingplan/components/category_list.dart';
import 'package:fit_master/Screens/trainingplan/components/training_card.dart';
import 'package:fit_master/domain/Workout.dart';
import 'package:fit_master/service/db_helper.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final String title;

  Body({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }
}

class _DBTestPageState extends State<Body> {
  var dbHelper;
  Future<List<Workout>> workouts;
  String token;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }

  refreshList() async {
    setState(() {
      workouts = dbHelper.getWorkouts();
    });
    token = await dbHelper.storedRefreshToken;
  }

  Stack dataWorkouts(List<Workout> workouts) {
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
          itemCount: workouts.length,
          itemBuilder: (context, index) => WorkoutCard(
            itemIndex: index,
            workout: workouts[index],
            token: token,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExercisesScreen(
                    workout: workouts[index],
                      token: token
                  ),
                ),
              );
            },
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
          CategoryList(),
          SizedBox(height: 20.0 / 2),
          Expanded(
            child: FutureBuilder(
              future: workouts,
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
