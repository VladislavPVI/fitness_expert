class WorkoutExercises {
  int workoutId, exerciseId, time;

  WorkoutExercises(this.workoutId, this.exerciseId, this.time);

  Map<String, dynamic> toMap() {
    return {'workoutId': workoutId, 'exerciseId': exerciseId, 'time': time};
  }

  WorkoutExercises.fromMap(Map<String, dynamic> map) {
    workoutId = map[workoutId];
    exerciseId = map[exerciseId];
    time = map[time];
  }
}
