class Workout {
  String image, title, description, imageURL;
  int id, time, level;

  Workout(
      this.image, this.title, this.description, this.id, this.time, this.level);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'image': image,
      'level': level
    };
  }

  Workout.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    time = map['time'];
    image = map['image'];
    level = map['level'];
  }

  Workout.fromMapCuba(Map<String, dynamic> map) {
    id = int.parse(map['id']);
    title = map['title'];
    description = map['description'];
    time = map['time'];
    imageURL = map['image']['id'];
    level = map['level'];
  }
}
