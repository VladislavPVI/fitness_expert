import 'package:fit_master/domain/Exercise.dart';

class ExerciseTime {
  int time, id, type;
  String imageURL, title, description, image;

  ExerciseTime(this.image, this.title, this.description, this.id, this.type,
      this.time);

  ExerciseTime.fromMapCuba(Map<String, dynamic> map) {
    id = int.parse(map['exercise']['id']);
    time = map['time'];
    imageURL = map['exercise']['image']['id'];
    title = map['exercise']['title'];
    description = map['exercise']['description'];
    type = map['exercise']['type'];
  }
}
