class Exercise {
  String image, title, description;
  int id, type;

  Exercise(this.image, this.title, this.description, this.id, this.type);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'type': type
    };
  }

  Exercise.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    image = map['image'];
    type = map['type'];
  }
}
