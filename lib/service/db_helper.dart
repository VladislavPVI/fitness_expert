import 'dart:async';
import 'dart:math';
import 'package:fit_master/domain/Exercise.dart';
import 'package:fit_master/domain/ExerciseTime.dart';
import 'package:fit_master/domain/Workout.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String TIME = 'time';
  static const String LEVEL = 'level';
  static const String TYPE = 'type';
  static const String IMAGE = 'image';
  static const String DESCRIPTION = 'description';

  static const String WORKOUT_ID = 'workoutId';
  static const String EXERCISE_ID = 'exerciseId';

  static const String TABLE_EXERCISE = 'Exercise';
  static const String TABLE_WORKOUT = 'Workout';
  static const String WORKOUT_EXERCISE = 'WorkoutExercise';
  static const String DB_NAME = 'fit_masterDB.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE_EXERCISE ($ID INTEGER PRIMARY KEY, $TYPE INTEGER, $IMAGE TEXT, $TITLE TEXT, $DESCRIPTION TEXT)");
    await db.execute(
        "CREATE TABLE $TABLE_WORKOUT ($ID INTEGER PRIMARY KEY, $TIME INTEGER, $LEVEL INTEGER, $IMAGE TEXT, $TITLE TEXT, $DESCRIPTION TEXT)");
    await db.execute(
        "CREATE TABLE $WORKOUT_EXERCISE ($WORKOUT_ID INTEGER, $EXERCISE_ID INTEGER, $TIME INTEGER, PRIMARY KEY ($WORKOUT_ID, $EXERCISE_ID))");
    Batch batch = db.batch();
    batch.insert(TABLE_EXERCISE, {
      'id': 1,
      'title': 'JUMPING JACKS',
      'description':
          'Start standing up with your legs together, a slight bend in knees, and hands resting on thighs. Keeping the knees bent, open the arms and legs out to the sides. Arms come above the head and legs wider than shoulders. Close your arms and legs back to your sides, returning to your start.',
      'type': 0,
      'image': "assets/images/jumping.jpg"
    });
    batch.insert(TABLE_EXERCISE, {
      'id': 2,
      'title': 'ABDOMINAL CRUNCHES',
      'description':
          'Lie down on your back. Plant your feet on the floor, hip-width apart. Bend your knees and place your arms across your chest. Contract your abs and inhale.Exhale and lift your upper body, keeping your head and neck relaxed.Inhale and return to the starting position.',
      'type': 1,
      'image': "assets/images/abdominl.jpg"
    });
    batch.insert(TABLE_EXERCISE, {
      'id': 3,
      'title': 'RUSSIAN TWIST',
      'description':
          'Sit on your sit bones as you lift your feet from the floor, keeping your knees bent.Elongate and straighten your spine at a 45-degree angle from the floor, creating a V shape with your torso and thighs.Reach your arms straight out in front, interlacing your fingers or clasping your hands together.Use your abdominals to twist to the right, then back to center, and then to the left.',
      'type': 1,
      'image': "assets/images/rtwist.png"
    });
    batch.insert(TABLE_EXERCISE, {
      'id': 4,
      'title': 'MOUNTAIN CLIMBER',
      'description':
          'Get into a plank position, making sure to distribute your weight evenly between your hands and your toes.Check your form—your hands should be about shoulder-width apart, back flat, abs engaged, and head in alignment.Pull your right knee into your chest as far as you can.Switch legs, pulling one knee out and bringing the other knee in.Keep your hips down, run your knees in and out as far and as fast as you can. Alternate inhaling and exhaling with each leg change.',
      'type': 1,
      'image': "assets/images/mclimber.jpg"
    });
    batch.insert(TABLE_EXERCISE, {
      'id': 5,
      'title': 'HEEL TOUCH',
      'description':
          'Start off laying with your back flat on the floor, keeping your knees bent, feet grounded and arms at your sides. Slowly reach down towards your right heel with your right arm as far as possible until you feel a stretch in your right oblique. Return to the starting position and repeat in the opposite direction.',
      'type': 1,
      'image': "assets/images/heel.png"
    });
    batch.insert(TABLE_WORKOUT, {
      'id': 2,
      'title': 'ABS BEGINNER',
      'description': 'The recipe for six-pack abs isn’t all that complicated!',
      'time': 20,
      'level': 0,
      'image': "assets/images/abs.jpg"
    });
    batch.insert(TABLE_WORKOUT, {
      'id': 1,
      'title': 'FULL BODY',
      'description':
          'One of the best workout splits for muscle growth and strength!',
      'time': 10,
      'level': 0,
      'image': "assets/images/0.jpg"
    });
    batch.insert(TABLE_WORKOUT, {
      'id': 3,
      'title': 'CHEST INTER',
      'description':
          'If you want huge pecs - challenge all of your chest muscles.',
      'time': 15,
      'level': 1,
      'image': "assets/images/chest.jpg"
    });
    batch.insert(TABLE_WORKOUT, {
      'id': 4,
      'title': 'LEG ADV',
      'description': 'The most enthusiastic gym-goer with trepidation.',
      'time': 53,
      'level': 2,
      'image': "assets/images/leg.png"
    });

    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 1, 'exerciseId': 1, 'time': 20});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 1, 'exerciseId': 2, 'time': 16});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 1, 'exerciseId': 3, 'time': 20});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 1, 'exerciseId': 4, 'time': 16});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 1, 'exerciseId': 5, 'time': 20});

    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 2, 'exerciseId': 1, 'time': 10});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 2, 'exerciseId': 2, 'time': 20});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 2, 'exerciseId': 3, 'time': 30});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 2, 'exerciseId': 4, 'time': 10});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 2, 'exerciseId': 5, 'time': 15});

    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 3, 'exerciseId': 1, 'time': 10});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 3, 'exerciseId': 2, 'time': 25});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 3, 'exerciseId': 3, 'time': 35});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 3, 'exerciseId': 4, 'time': 21});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 3, 'exerciseId': 5, 'time': 40});

    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 4, 'exerciseId': 1, 'time': 20});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 4, 'exerciseId': 2, 'time': 10});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 4, 'exerciseId': 3, 'time': 20});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 4, 'exerciseId': 4, 'time': 10});
    batch.insert(
        WORKOUT_EXERCISE, {'workoutId': 4, 'exerciseId': 5, 'time': 10});

    await batch.commit(noResult: true);
  }

  Future<Exercise> saveExercise(Exercise exercise) async {
    var dbClient = await db;
    exercise.id = await dbClient.insert(TABLE_EXERCISE, exercise.toMap());
    return exercise;
  }

  Future<Workout> saveWorkout(Workout workout) async {
    var dbClient = await db;
    workout.id = await dbClient.insert(TABLE_WORKOUT, workout.toMap());
    int count = Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $TABLE_EXERCISE'));

    Batch batch = dbClient.batch();

    Random random = new Random();

    List list = List.generate(count, (i) => i);
    list.shuffle();

    for (int i = 0; i < 5; i++) {
      int exID = list[i] + 1;
      int time = random.nextInt(40) + 10;
      batch.insert(WORKOUT_EXERCISE,
          {'workoutId': workout.id, 'exerciseId': exID, 'time': time});
    }
    await batch.commit(noResult: true);
    return workout;
  }

  Future<List<Exercise>> getExercise() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE_EXERCISE, columns: [ID, TYPE, IMAGE, TITLE, DESCRIPTION]);
    List<Exercise> exercises = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        exercises.add(Exercise.fromMap(maps[i]));
      }
    }
    return exercises;
  }

  Future<List<Exercise>> getUserExercise() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.rawQuery("SELECT * FROM $TABLE_EXERCISE WHERE $ID>5");
    List<Exercise> exercises = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        exercises.add(Exercise.fromMap(maps[i]));
      }
    }
    return exercises;
  }

  Future<List<Workout>> getUserPlans() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.rawQuery("SELECT * FROM $TABLE_WORKOUT WHERE $ID>4");
    List<Workout> workouts = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        workouts.add(Workout.fromMap(maps[i]));
      }
    }
    return workouts;
  }

  Future<List<ExerciseTime>> getExercisesByWorkoutId(int workoutId) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $WORKOUT_EXERCISE WHERE $WORKOUT_ID=$workoutId");
    List<ExerciseTime> exercises = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        int id = maps[i][EXERCISE_ID];
        List<Map> map = await dbClient
            .rawQuery("SELECT * FROM $TABLE_EXERCISE WHERE $ID=$id");
        ExerciseTime exerciseTime = ExerciseTime(
            map[0]['image'],
            map[0]['title'],
            map[0]['description'],
            map[0]['id'],
            map[0]['type'],
            maps[i]['time']);
        exercises.add(exerciseTime);
      }
    }
    return exercises;
  }

  Future<List<Workout>> getWorkouts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE_WORKOUT,
        columns: [ID, TIME, LEVEL, IMAGE, TITLE, DESCRIPTION]);
    List<Workout> workouts = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        workouts.add(Workout.fromMap(maps[i]));
      }
    }
    return workouts;
  }

  Future<int> deleteExercise(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE_EXERCISE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> deleteWorkout(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE_WORKOUT, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateExercise(Exercise exercise) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_EXERCISE, exercise.toMap(),
        where: '$ID = ?', whereArgs: [exercise.id]);
  }

  Future<int> updateWorkout(Workout workout) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_WORKOUT, workout.toMap(),
        where: '$ID = ?', whereArgs: [workout.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
