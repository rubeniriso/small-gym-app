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

  /// Monday a 12-week template starts. A custom pattern stores its start
  /// date here instead, and that date does not have to be a Monday.
  TextColumn get anchorMonday => text().nullable()();

  /// `static` follows the week. `dynamic` is chosen each day.
  TextColumn get kind => text().withDefault(const Constant('static'))();
  BoolColumn get incrementsEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Added after a finished session. Zero adds nothing.
  RealColumn get incrementAmount => real().withDefault(const Constant(2.5))();

  /// `kg` adds that many kilograms. `percent` adds that share of the weight.
  TextColumn get incrementUnit => text().withDefault(const Constant('kg'))();

  /// Default rest between strength sets, in seconds.
  IntColumn get restSeconds => integer().withDefault(const Constant(90))();
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

  /// Jogging length in seconds.
  ///
  /// Databases created before schema 7 stored whole minutes. That upgrade
  /// multiplies the stored value by 60.
  IntColumn get targetMinutes => integer().nullable()();
  RealColumn get targetSpeedKmh => real().nullable()();

  /// Overrides the routine rest. Null uses the routine default.
  IntColumn get restSeconds => integer().nullable()();

  /// Overrides the routine increment. Null uses the routine default.
  RealColumn get incrementAmount => real().nullable()();
  TextColumn get incrementUnit => text().nullable()();

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

  /// Reps this log belongs to, so 4-rep and 8-rep bench stay separate.
  IntColumn get targetReps => integer().nullable()();
}

@DataClassName('CustomExercise')
class CustomExercises extends Table {
  TextColumn get storageKey => text()();
  TextColumn get name => text()();
  TextColumn get muscleGroup => text()();
  TextColumn get equipment => text()();
  TextColumn get kind => text().withDefault(const Constant('strength'))();

  @override
  Set<Column<Object>> get primaryKey => {storageKey};
}

@DataClassName('DayPick')
class DayPicks extends Table {
  IntColumn get routineId => integer().references(Routines, #id)();
  TextColumn get day => text()();
  IntColumn get workoutId => integer().references(Workouts, #id)();

  @override
  Set<Column<Object>> get primaryKey => {routineId, day};
}

@DataClassName('SetLog')
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseLogId => integer().references(ExerciseLogs, #id)();
  IntColumn get setIndex => integer()();
  IntColumn get reps => integer()();

  /// Strength sets keep their own weight. Cardio leaves this empty.
  RealColumn get weightKg => real().nullable()();

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
    DayPicks,
    CustomExercises,
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
  int get schemaVersion => 9;

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
      if (from < 5) {
        await migrator.addColumn(routines, routines.kind);
        await migrator.addColumn(routines, routines.incrementsEnabled);
        await migrator.addColumn(exerciseLogs, exerciseLogs.targetReps);
        await migrator.createTable(dayPicks);
      }
      if (from < 6) {
        await migrator.addColumn(routines, routines.restSeconds);
        await migrator.addColumn(
          workoutExercises,
          workoutExercises.restSeconds,
        );
        await migrator.addColumn(setLogs, setLogs.weightKg);
      }
      if (from < 7) {
        await customStatement('''
          UPDATE workout_exercises
          SET target_minutes = target_minutes * 60
          WHERE target_minutes IS NOT NULL
        ''');
      }
      if (from < 8) {
        await migrator.addColumn(routines, routines.incrementAmount);
        await migrator.addColumn(routines, routines.incrementUnit);
        await migrator.addColumn(
          workoutExercises,
          workoutExercises.incrementAmount,
        );
        await migrator.addColumn(
          workoutExercises,
          workoutExercises.incrementUnit,
        );
        await customStatement('''
          UPDATE routines
          SET increment_amount = 0
          WHERE increments_enabled = 0
        ''');
      }
      if (from < 9) {
        await migrator.createTable(customExercises);
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
