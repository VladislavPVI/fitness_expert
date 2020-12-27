import 'package:fit_master/Screens/exercises/components/body.dart';
import 'package:fit_master/domain/Workout.dart';
import 'package:flutter/material.dart';

class ExercisesScreen extends StatelessWidget {
  final Workout workout;

  const ExercisesScreen({Key key, this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF035AA6),
      body: Body(workout: workout),
    );
  }
}
