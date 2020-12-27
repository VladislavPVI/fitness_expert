import 'package:fit_master/domain/Exercise.dart';

class ExerciseTime extends Exercise {
  final int time;

  ExerciseTime(String image, String title, String description, int id, int type,
      this.time)
      : super(image, title, description, id, type);
}
