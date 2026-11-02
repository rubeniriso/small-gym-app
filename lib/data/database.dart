import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName('AppSetting')
class AppSettings extends Table {
  IntColumn get id => integer()();
  IntColumn get currentRoutineId =>
      integer().nullable().references(Routines, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('Routine')
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get anchorMonday => text().nullable()();
}

@DataClassName('Workout')
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();
  TextColumn get name => text()();
  IntColumn get position => integer()();
}

@DataClassName('WorkoutExercise')
class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutId => integer().references(Workouts, #id)();
  IntColumn get position => integer()();
  IntColumn get sets => integer()();
  IntColumn get reps => integer()();
  TextColumn get exercise => text().map(const ExerciseConverter())();
  RealColumn get targetWeightKg => real().nullable()();
  IntColumn get targetMinutes => integer().nullable()();
  RealColumn get targetSpeedKmh => real().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {workoutId, exercise},
  ];
}

@DataClassName('SprintIntervalTarget')
class SprintIntervalTargets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutExerciseId =>
      integer().references(WorkoutExercises, #id)();
  IntColumn get intervalIndex => integer()();
  RealColumn get speedKmh => real()();
  IntColumn get durationSeconds => integer()();
  TextColumn get durationUnit => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {workoutExerciseId, intervalIndex},
  ];
}

@DataClassName('RoutineWeekday')
class RoutineWeekdays extends Table {
  IntColumn get routineId => integer().references(Routines, #id)();
  IntColumn get weekday => integer()();
  BoolColumn get isRest => boolean()();
  IntColumn get workoutId => integer().nullable().references(Workouts, #id)();

  @override
  Set<Column<Object>> get primaryKey => {routineId, weekday};
}

@DataClassName('TrainingSlot')
class TrainingSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();
  IntColumn get sequenceIndex => integer()();
  IntColumn get workoutId => integer().references(Workouts, #id)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {routineId, sequenceIndex},
  ];
}

@DataClassName('ExerciseStart')
class ExerciseStarts extends Table {
  IntColumn get routineId => integer().references(Routines, #id)();
  TextColumn get exercise => text().map(const ExerciseConverter())();
  RealColumn get startWeightKg => real()();

  @override
  Set<Column<Object>> get primaryKey => {routineId, exercise};
}

@DataClassName('Session')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();
  TextColumn get loggedOn => text()();
  IntColumn get trainingSlotId =>
      integer().nullable().references(TrainingSlots, #id)();
  IntColumn get workoutId => integer().references(Workouts, #id)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {routineId, loggedOn},
  ];
}

@DataClassName('ExerciseLog')
class ExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  TextColumn get exercise => text().map(const ExerciseConverter())();
  RealColumn get weightKg => real()();
}

@DataClassName('SetLog')
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseLogId => integer().references(ExerciseLogs, #id)();
  IntColumn get setIndex => integer()();
  IntColumn get reps => integer()();

  /// Jogging and sprinting. Strength leaves these empty.
  RealColumn get speedKmh => real().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  TextColumn get durationUnit => text().nullable()();
}

@DriftDatabase(
  tables: [
    AppSettings,
    Routines,
    Workouts,
    WorkoutExercises,
    RoutineWeekdays,
    TrainingSlots,
    ExerciseStarts,
    Sessions,
    ExerciseLogs,
    SetLogs,
    SprintIntervalTargets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.memory() : super(NativeDatabase.memory());

  static Future<AppDatabase> openOnDevice() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'gym.sqlite'));
    return AppDatabase(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(setLogs, setLogs.speedKmh);
        await migrator.addColumn(setLogs, setLogs.durationSeconds);
        await migrator.addColumn(setLogs, setLogs.durationUnit);
      }
      if (from < 3) {
        await migrator.addColumn(
          workoutExercises,
          workoutExercises.targetWeightKg,
        );
        await migrator.addColumn(
          workoutExercises,
          workoutExercises.targetMinutes,
        );
        await migrator.addColumn(
          workoutExercises,
          workoutExercises.targetSpeedKmh,
        );
        await customStatement('''
          UPDATE workout_exercises
          SET target_weight_kg = (
            SELECT es.start_weight_kg
            FROM exercise_starts es
            INNER JOIN workouts w ON w.id = workout_exercises.workout_id
            WHERE es.routine_id = w.routine_id
              AND es.exercise = workout_exercises.exercise
          )
          WHERE target_weight_kg IS NULL
        ''');
      }
      if (from < 4) {
        await migrator.createTable(sprintIntervalTargets);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement(
        'INSERT OR IGNORE INTO app_settings (id, current_routine_id) VALUES (1, NULL)',
      );
    },
  );
}
