import 'dart:async';
import 'dart:convert';
import 'package:fit_master/domain/Exercise.dart';
import 'package:fit_master/domain/ExerciseTime.dart';
import 'package:fit_master/domain/Workout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class DBHelper {
  static Database _db;
  static String _storedRefreshToken;
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

  Future<String> get storedRefreshToken async {
    if (_storedRefreshToken != null) {
      return _storedRefreshToken;
    }
    _storedRefreshToken = await initToken();
    return _storedRefreshToken;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  initToken() async {
    String token = await secureStorage.read(key: 'access_token');
    return token;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE_EXERCISE ($ID INTEGER PRIMARY KEY, $TYPE INTEGER, $IMAGE TEXT, $TITLE TEXT, $DESCRIPTION TEXT)");
    await db.execute(
        "CREATE TABLE $TABLE_WORKOUT ($ID INTEGER PRIMARY KEY, $TIME INTEGER, $LEVEL INTEGER, $IMAGE TEXT, $TITLE TEXT, $DESCRIPTION TEXT)");
    await db.execute(
        "CREATE TABLE $WORKOUT_EXERCISE ($WORKOUT_ID INTEGER, $EXERCISE_ID INTEGER, $TIME INTEGER, PRIMARY KEY ($WORKOUT_ID, $EXERCISE_ID))");

    String token = await storedRefreshToken;

    if (token != null) {
      try {
        initDBfromCuba(db, token);
      } catch (e) {
        print(e);
        initDBNoConnection(db);
      }
    } else
      initDBNoConnection(db);
  }

  initDBNoConnection(Database db) async {
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

  initDBfromCuba(Database db, String token) async {
    Batch batch = db.batch();
    var res = await http.get(
        'http://192.168.31.119:3000/app/rest/v2/entities/fitnessexpertback_Workout?view=workout-view',
        headers: {"Authorization": 'Bearer ' + token});
    var res2 = json.decode(res.body);

    for (var map in res2) {
      batch.insert(TABLE_WORKOUT, {
        'id': int.parse(map['id']),
        'title': map['title'],
        'description': map['description'],
        'time': map['time'],
        'level': map['level'],
        'image': "assets/images/0.jpg"
      });
    }

    res = await http.get(
        'http://192.168.31.119:3000/app/rest/v2/entities/fitnessexpertback_Exercise?view=exercise-view',
        headers: {"Authorization": 'Bearer ' + token});
    res2 = json.decode(res.body);

    for (var map in res2) {
      batch.insert(TABLE_EXERCISE, {
        'id': int.parse(map['id']),
        'title': map['title'],
        'description': map['description'],
        'type': map['type'],
        'image': "assets/images/1.jpg"
      });
    }

    res = await http.get(
        'http://192.168.31.119:3000/app/rest/v2/entities/fitnessexpertback_WorkoutExercise?view=workoutExercise-view_1',
        headers: {"Authorization": 'Bearer ' + token});
    res2 = json.decode(res.body);

    for (var map in res2) {
      batch.insert(WORKOUT_EXERCISE, {
        'workoutId': int.parse(map['workout']['id']),
        'exerciseId': int.parse(map['exercise']['id']),
        'time': map['time']
      });
    }

    await batch.commit(noResult: true);
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

  Future<List<ExerciseTime>> getExercisesByWorkoutId(int workoutId) async {
    List<ExerciseTime> exercises = [];
    String token = await storedRefreshToken;
    try {
      var b = {
        "filter": {
          "conditions": [
            {"property": "workout.id", "operator": "=", "value": workoutId}
          ]
        },
        "view": "workoutExercise-view"
      };

      var res = await http.post(
          'http://192.168.31.119:3000/app/rest/v2/entities/fitnessexpertback_WorkoutExercise/search',
          body: jsonEncode(b),
          headers: {"Authorization": 'Bearer ' + token});
      var res2 = json.decode(res.body);
      for (int i = 0; i < res2.length; i++) {
        exercises.add(ExerciseTime.fromMapCuba(res2[i]));
      }
    } catch (e) {
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery(
          "SELECT * FROM $WORKOUT_EXERCISE WHERE $WORKOUT_ID=$workoutId");

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
    }
    return exercises;
  }

  Future<List<Workout>> getWorkouts() async {
    var dbClient = await db;
    String token = await storedRefreshToken;
    List<Workout> workouts = [];

    try {
      var res = await http.get(
          'http://192.168.31.119:3000/app/rest/v2/entities/fitnessexpertback_Workout?view=workout-view',
          headers: {"Authorization": 'Bearer ' + token});
      var res2 = json.decode(res.body);
      for (int i = 0; i < res2.length; i++) {
        workouts.add(Workout.fromMapCuba(res2[i]));
      }
    } catch (e) {
      List<Map> maps = await dbClient.query(TABLE_WORKOUT,
          columns: [ID, TIME, LEVEL, IMAGE, TITLE, DESCRIPTION]);

      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          workouts.add(Workout.fromMap(maps[i]));
        }
      }
    }

    return workouts;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
