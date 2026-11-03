import 'package:drift/drift.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/routine_kind.dart';
import 'package:gym_app/domain/schedule.dart';
import 'package:gym_app/domain/template_file.dart';

class GymRepository {
  GymRepository(this._db);

  final AppDatabase _db;

  /// Loads this database's custom exercises. Each call rereads the table so
  /// another open database cannot leave stale names in the shared catalog.
  Future<void> loadCatalog() {
    return _readCatalog();
  }

  Future<void> _readCatalog() async {
    final rows = await _db.select(_db.customExercises).get();
    Exercise.replaceCustomExercises([
      for (final row in rows)
        Exercise(
          storageKey: row.storageKey,
          label: row.name,
          muscleGroup: MuscleGroup.fromStorage(row.muscleGroup),
          equipment: Equipment.fromStorage(row.equipment),
          kind: ExerciseKind.fromStorage(row.kind),
          custom: true,
        ),
    ]);
  }

  Future<List<Exercise>> exercises() async {
    await loadCatalog();
    return Exercise.catalog;
  }

  Future<Exercise> createExercise({
    required String name,
    required MuscleGroup muscleGroup,
    required Equipment equipment,
    required ExerciseKind kind,
  }) async {
    await loadCatalog();
    final clean = _requireName(name).replaceAll(RegExp(r'\s+'), ' ');
    final taken = Exercise.catalog.any(
      (exercise) => exercise.label.toLowerCase() == clean.toLowerCase(),
    );
    if (taken) {
      throw ArgumentError('That exercise already exists.');
    }
    final cardio = kind != ExerciseKind.strength;
    final exercise = Exercise(
      storageKey: _customKey(clean),
      label: clean,
      muscleGroup: cardio ? MuscleGroup.cardio : muscleGroup,
      equipment: equipment,
      kind: kind,
      custom: true,
    );
    await _db
        .into(_db.customExercises)
        .insert(
          CustomExercisesCompanion.insert(
            storageKey: exercise.storageKey,
            name: exercise.label,
            muscleGroup: exercise.muscleGroup.name,
            equipment: exercise.equipment.name,
            kind: Value(exercise.kind.name),
          ),
        );
    return Exercise.register(exercise);
  }

  Future<List<RoutineListItem>> listRoutines() async {
    final currentId = await currentRoutineId();
    final rows =
        await (_db.select(_db.routines)..orderBy([
              (row) => OrderingTerm.asc(row.createdAt),
              (row) => OrderingTerm.asc(row.id),
            ]))
            .get();
    return [
      for (final row in rows)
        RoutineListItem(
          id: row.id,
          name: row.name,
          isCurrent: row.id == currentId,
          isTemplate:
              row.anchorMonday != null &&
              RoutineKind.fromStorage(row.kind) != RoutineKind.customPattern,
          kind: RoutineKind.fromStorage(row.kind),
        ),
    ];
  }

  Future<int?> currentRoutineId() async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((row) => row.id.equals(1))).getSingle();
    return row.currentRoutineId;
  }

  Future<int> createRoutine(
    String name, {
    RoutineKind kind = RoutineKind.staticWeek,
    WeightIncrement increment = standardIncrement,
    int restSeconds = defaultRestSeconds,
    DateTime? anchorMonday,
    DateTime? patternStart,
  }) {
    final cleanName = _requireName(name);
    final String? anchor;
    if (restSeconds < 0) {
      throw ArgumentError('Enter the rest.');
    }
    final step = _requireIncrement(increment);
    final pattern = kind == RoutineKind.customPattern;
    if (pattern) {
      // The start date lives in anchor_monday. It is not a template anchor.
      anchor = formatIsoDate(dateOnly(patternStart ?? DateTime.now()));
    } else if (anchorMonday == null) {
      anchor = null;
    } else {
      final day = dateOnly(anchorMonday);
      if (day.weekday != DateTime.monday) {
        throw ArgumentError('Choose a Monday.');
      }
      anchor = formatIsoDate(day);
    }
    return _db.transaction(() async {
      final id = await _db
          .into(_db.routines)
          .insert(
            RoutinesCompanion.insert(
              name: cleanName,
              anchorMonday: Value(anchor),
              kind: Value(kind.storageKey),
              incrementsEnabled: Value(step.amount > 0),
              incrementAmount: Value(step.amount),
              incrementUnit: Value(step.unit.storageKey),
              restSeconds: Value(restSeconds),
            ),
          );
      if (!pattern) {
        for (
          var weekday = DateTime.monday;
          weekday <= DateTime.sunday;
          weekday++
        ) {
          await _db
              .into(_db.routineWeekdays)
              .insert(
                RoutineWeekdaysCompanion.insert(
                  routineId: id,
                  weekday: weekday,
                  isRest: true,
                ),
              );
        }
      }
      return id;
    });
  }

  Future<void> deleteRoutine(int id) {
    return _db.transaction(() async {
      final currentId = await currentRoutineId();
      if (currentId == id) {
        await (_db.update(
          _db.appSettings,
        )..where((row) => row.id.equals(1))).write(
          const AppSettingsCompanion(currentRoutineId: Value<int?>(null)),
        );
      }

      final sessions = await (_db.select(
        _db.sessions,
      )..where((row) => row.routineId.equals(id))).get();
      for (final session in sessions) {
        await _deleteSession(session.id);
      }
      await (_db.delete(
        _db.trainingSlots,
      )..where((row) => row.routineId.equals(id))).go();
      await (_db.delete(
        _db.exerciseStarts,
      )..where((row) => row.routineId.equals(id))).go();
      await (_db.delete(
        _db.routineWeekdays,
      )..where((row) => row.routineId.equals(id))).go();
      await (_db.delete(
        _db.dayPicks,
      )..where((row) => row.routineId.equals(id))).go();

      final workouts = await (_db.select(
        _db.workouts,
      )..where((row) => row.routineId.equals(id))).get();
      for (final workout in workouts) {
        final exerciseRows = await (_db.select(
          _db.workoutExercises,
        )..where((row) => row.workoutId.equals(workout.id))).get();
        for (final exercise in exerciseRows) {
          await (_db.delete(
            _db.sprintIntervalTargets,
          )..where((row) => row.workoutExerciseId.equals(exercise.id))).go();
        }
        await (_db.delete(
          _db.workoutExercises,
        )..where((row) => row.workoutId.equals(workout.id))).go();
      }
      await (_db.delete(
        _db.workouts,
      )..where((row) => row.routineId.equals(id))).go();
      await (_db.delete(_db.routines)..where((row) => row.id.equals(id))).go();
    });
  }

  Future<void> setCurrentRoutine(int id) async {
    final routine = await (_db.select(
      _db.routines,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (routine == null) {
      throw ArgumentError('That routine is gone.');
    }
    await (_db.update(_db.appSettings)..where((row) => row.id.equals(1))).write(
      AppSettingsCompanion(currentRoutineId: Value(id)),
    );
  }

  Future<int> createFromTemplate({
    required String name,
    required DateTime anchorMonday,
    required Map<Exercise, double> startWeightsKg,
  }) {
    final cleanName = _requireName(name);
    final anchor = dateOnly(anchorMonday);
    if (anchor.weekday != DateTime.monday) {
      throw ArgumentError('Choose a Monday.');
    }
    final weights = <Exercise, double>{};
    for (final exercise in Exercise.strongLifts) {
      final weight = startWeightsKg[exercise];
      if (weight == null || weight < 0 || weight.isNaN || weight.isInfinite) {
        throw ArgumentError('Enter a weight for every exercise.');
      }
      weights[exercise] = roundKg(weight);
    }

    return _db.transaction(() async {
      final routineId = await _db
          .into(_db.routines)
          .insert(
            RoutinesCompanion.insert(
              name: cleanName,
              anchorMonday: Value(formatIsoDate(anchor)),
            ),
          );
      final workoutA = await _insertWorkout(
        routineId: routineId,
        name: 'Workout A',
        position: 0,
        exercises: const [
          Exercise.squat,
          Exercise.benchPress,
          Exercise.barbellRow,
        ],
        targetWeightsKg: weights,
      );
      final workoutB = await _insertWorkout(
        routineId: routineId,
        name: 'Workout B',
        position: 1,
        exercises: const [
          Exercise.squat,
          Exercise.overheadPress,
          Exercise.deadlift,
        ],
        targetWeightsKg: weights,
      );

      for (
        var weekday = DateTime.monday;
        weekday <= DateTime.sunday;
        weekday++
      ) {
        await _db
            .into(_db.routineWeekdays)
            .insert(
              RoutineWeekdaysCompanion.insert(
                routineId: routineId,
                weekday: weekday,
                isRest: !isTemplateTrainingWeekday(weekday),
              ),
            );
      }

      for (var sequence = 0; sequence < templateSessionCount; sequence++) {
        await _db
            .into(_db.trainingSlots)
            .insert(
              TrainingSlotsCompanion.insert(
                routineId: routineId,
                sequenceIndex: sequence,
                workoutId: sequence.isEven ? workoutA : workoutB,
              ),
            );
      }

      for (final exercise in Exercise.strongLifts) {
        await _db
            .into(_db.exerciseStarts)
            .insert(
              ExerciseStartsCompanion.insert(
                routineId: routineId,
                exercise: exercise,
                startWeightKg: weights[exercise]!,
              ),
            );
      }

      await setCurrentRoutine(routineId);
      return routineId;
    });
  }

  Future<RoutineDetails> routineDetails(int id) async {
    final routine = await (_db.select(
      _db.routines,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (routine == null) {
      throw ArgumentError('That routine is gone.');
    }
    final currentId = await currentRoutineId();
    final days =
        await (_db.select(_db.routineWeekdays)
              ..where((row) => row.routineId.equals(id))
              ..orderBy([(row) => OrderingTerm.asc(row.weekday)]))
            .get();
    final workouts =
        await (_db.select(_db.workouts)
              ..where((row) => row.routineId.equals(id))
              ..orderBy([(row) => OrderingTerm.asc(row.position)]))
            .get();
    final names = {for (final workout in workouts) workout.id: workout.name};
    final starts = await (_db.select(
      _db.exerciseStarts,
    )..where((row) => row.routineId.equals(id))).get();
    final kind = RoutineKind.fromStorage(routine.kind);
    final pattern = kind == RoutineKind.customPattern;
    final storedStart = routine.anchorMonday == null
        ? null
        : parseIsoDate(routine.anchorMonday!);

    return RoutineDetails(
      id: routine.id,
      name: routine.name,
      isCurrent: routine.id == currentId,
      anchorMonday: pattern ? null : storedStart,
      patternStart: pattern ? storedStart : null,
      kind: kind,
      increment: WeightIncrement(
        unit: IncrementUnit.fromStorage(routine.incrementUnit),
        amount: routine.incrementAmount,
      ),
      restSeconds: routine.restSeconds,
      days: [
        if (!pattern)
          for (final day in days)
            WeekdayRow(
              weekday: day.weekday,
              isRest: day.isRest,
              workoutId: day.workoutId,
              workoutName: day.workoutId == null ? null : names[day.workoutId!],
            ),
      ],
      pattern: [
        if (pattern)
          for (final day in days)
            PatternDayRow(
              position: day.weekday,
              isRest: day.isRest,
              workoutId: day.workoutId,
              workoutName: day.workoutId == null ? null : names[day.workoutId!],
            ),
      ],
      workouts: [
        for (final workout in workouts)
          WorkoutSummary(
            id: workout.id,
            name: workout.name,
            position: workout.position,
          ),
      ],
      startWeightsKg: {
        for (final start in starts) start.exercise: start.startWeightKg,
      },
    );
  }

  Future<void> setWeekday({
    required int routineId,
    required int weekday,
    required bool isRest,
    int? workoutId,
  }) async {
    if (weekday < DateTime.monday || weekday > DateTime.sunday) {
      throw ArgumentError('Choose a day of the week.');
    }
    final int? linkedId = isRest ? null : workoutId;
    if (linkedId != null) {
      final workout = await (_db.select(
        _db.workouts,
      )..where((row) => row.id.equals(linkedId))).getSingleOrNull();
      if (workout == null || workout.routineId != routineId) {
        throw ArgumentError('That workout is not in this routine.');
      }
    }

    final updated =
        await (_db.update(_db.routineWeekdays)..where(
              (row) =>
                  row.routineId.equals(routineId) & row.weekday.equals(weekday),
            ))
            .write(
              RoutineWeekdaysCompanion(
                isRest: Value(isRest),
                workoutId: Value(linkedId),
              ),
            );
    if (updated == 0) {
      throw ArgumentError('That routine is gone.');
    }
  }

  Future<void> _requirePattern(int routineId) async {
    final routine = await (_db.select(
      _db.routines,
    )..where((row) => row.id.equals(routineId))).getSingleOrNull();
    if (routine == null) {
      throw ArgumentError('That routine is gone.');
    }
    if (RoutineKind.fromStorage(routine.kind) != RoutineKind.customPattern) {
      throw ArgumentError('This routine is not a custom pattern.');
    }
  }

  /// Appends a rest day. Positions stay contiguous and start at 1.
  Future<int> addPatternDay(int routineId) async {
    await _requirePattern(routineId);
    final rows = await (_db.select(
      _db.routineWeekdays,
    )..where((row) => row.routineId.equals(routineId))).get();
    final position = rows.isEmpty
        ? 1
        : rows
                  .map((row) => row.weekday)
                  .reduce((best, next) => next > best ? next : best) +
              1;
    await _db
        .into(_db.routineWeekdays)
        .insert(
          RoutineWeekdaysCompanion.insert(
            routineId: routineId,
            weekday: position,
            isRest: true,
          ),
        );
    return position;
  }

  Future<void> removePatternDay({
    required int routineId,
    required int position,
  }) async {
    await _requirePattern(routineId);
    await _db.transaction(() async {
      final removed =
          await (_db.delete(_db.routineWeekdays)..where(
                (row) =>
                    row.routineId.equals(routineId) &
                    row.weekday.equals(position),
              ))
              .go();
      if (removed == 0) {
        throw ArgumentError('That day is gone.');
      }
      final later =
          await (_db.select(_db.routineWeekdays)
                ..where(
                  (row) =>
                      row.routineId.equals(routineId) &
                      row.weekday.isBiggerThanValue(position),
                )
                ..orderBy([(row) => OrderingTerm.asc(row.weekday)]))
              .get();
      for (final row in later) {
        await (_db.update(_db.routineWeekdays)..where(
              (item) =>
                  item.routineId.equals(routineId) &
                  item.weekday.equals(row.weekday),
            ))
            .write(RoutineWeekdaysCompanion(weekday: Value(row.weekday - 1)));
      }
    });
  }

  Future<void> setPatternDay({
    required int routineId,
    required int position,
    required bool isRest,
    int? workoutId,
  }) async {
    await _requirePattern(routineId);
    if (position < 1) {
      throw ArgumentError('Choose a day.');
    }
    final int? linkedId = isRest ? null : workoutId;
    if (linkedId != null) {
      final workout = await (_db.select(
        _db.workouts,
      )..where((row) => row.id.equals(linkedId))).getSingleOrNull();
      if (workout == null || workout.routineId != routineId) {
        throw ArgumentError('That workout is not in this routine.');
      }
    }
    final updated =
        await (_db.update(_db.routineWeekdays)..where(
              (row) =>
                  row.routineId.equals(routineId) &
                  row.weekday.equals(position),
            ))
            .write(
              RoutineWeekdaysCompanion(
                isRest: Value(isRest),
                workoutId: Value(linkedId),
              ),
            );
    if (updated == 0) {
      throw ArgumentError('That day is gone.');
    }
  }

  Future<void> setPatternStart({
    required int routineId,
    required DateTime start,
  }) async {
    await _requirePattern(routineId);
    final updated =
        await (_db.update(
          _db.routines,
        )..where((row) => row.id.equals(routineId))).write(
          RoutinesCompanion(
            anchorMonday: Value(formatIsoDate(dateOnly(start))),
          ),
        );
    if (updated == 0) {
      throw ArgumentError('That routine is gone.');
    }
  }

  Future<int> createWorkout({
    required int routineId,
    required String name,
    int? linkWeekday,
    int? linkPatternPosition,
  }) {
    final cleanName = _requireName(name);
    return _db.transaction(() async {
      final existing = await (_db.select(
        _db.workouts,
      )..where((row) => row.routineId.equals(routineId))).get();
      final position = existing.isEmpty
          ? 0
          : existing
                    .map((workout) => workout.position)
                    .reduce((best, next) => next > best ? next : best) +
                1;
      final id = await _db
          .into(_db.workouts)
          .insert(
            WorkoutsCompanion.insert(
              routineId: routineId,
              name: cleanName,
              position: position,
            ),
          );
      if (linkWeekday != null) {
        await setWeekday(
          routineId: routineId,
          weekday: linkWeekday,
          isRest: false,
          workoutId: id,
        );
      }
      if (linkPatternPosition != null) {
        await setPatternDay(
          routineId: routineId,
          position: linkPatternPosition,
          isRest: false,
          workoutId: id,
        );
      }
      return id;
    });
  }

  Future<WorkoutDetails> workoutDetails(int id) async {
    final workout = await (_db.select(
      _db.workouts,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (workout == null) {
      throw ArgumentError('That workout is gone.');
    }
    final exercises =
        await (_db.select(_db.workoutExercises)
              ..where((row) => row.workoutId.equals(id))
              ..orderBy([(row) => OrderingTerm.asc(row.position)]))
            .get();
    final intervals = await _intervalsByExercise([
      for (final exercise in exercises) exercise.id,
    ]);
    return WorkoutDetails(
      id: workout.id,
      routineId: workout.routineId,
      name: workout.name,
      exercises: [
        for (final exercise in exercises)
          WorkoutExerciseDetails(
            id: exercise.id,
            exercise: exercise.exercise,
            sets: exercise.sets,
            reps: exercise.reps,
            position: exercise.position,
            targetWeightKg: exercise.targetWeightKg,
            targetDurationSeconds: exercise.targetMinutes,
            targetSpeedKmh: exercise.targetSpeedKmh,
            restSeconds: exercise.restSeconds,
            increment: _incrementOverride(
              exercise.incrementAmount,
              exercise.incrementUnit,
            ),
            intervals: intervals[exercise.id] ?? const [],
          ),
      ],
    );
  }

  Future<void> renameWorkout(int id, String name) async {
    final cleanName = _requireName(name);
    final updated =
        await (_db.update(_db.workouts)..where((row) => row.id.equals(id)))
            .write(WorkoutsCompanion(name: Value(cleanName)));
    if (updated == 0) {
      throw ArgumentError('That workout is gone.');
    }
  }

  Future<void> addExercise({
    required int workoutId,
    required Exercise exercise,
    int sets = 5,
    int reps = 5,
    double? targetWeightKg,
    int? targetDurationSeconds,
    double? targetSpeedKmh,
    int? restSeconds,
    WeightIncrement? increment,
    List<LoggedInterval> intervals = const [],
  }) async {
    final sprint = exercise.kind == ExerciseKind.sprinting
        ? _cleanIntervals(intervals)
        : const <LoggedInterval>[];
    if (exercise.kind == ExerciseKind.sprinting) {
      sets = sprint.length;
      reps = 1;
    }
    _requireCount(sets, 'sets');
    _requireCount(reps, 'reps');
    if (restSeconds != null && restSeconds < 0) {
      throw ArgumentError('Enter the rest.');
    }
    final step = increment == null ? null : _requireIncrement(increment);
    final targets = _targetsFor(
      exercise,
      targetWeightKg: targetWeightKg,
      targetDurationSeconds: targetDurationSeconds,
      targetSpeedKmh: targetSpeedKmh,
    );
    final workout = await workoutDetails(workoutId);
    if (workout.exercises.any((row) => row.exercise == exercise)) {
      throw ArgumentError('That exercise is already in this workout.');
    }
    final position = workout.exercises.isEmpty
        ? 0
        : workout.exercises.last.position + 1;
    final exerciseId = await _db
        .into(_db.workoutExercises)
        .insert(
          WorkoutExercisesCompanion.insert(
            workoutId: workoutId,
            position: position,
            sets: sets,
            reps: reps,
            exercise: exercise,
            targetWeightKg: Value(targets.weightKg),
            targetMinutes: Value(targets.seconds),
            targetSpeedKmh: Value(targets.speedKmh),
            restSeconds: Value(restSeconds),
            incrementAmount: Value(step?.amount),
            incrementUnit: Value(step?.unit.storageKey),
          ),
        );
    await _writeIntervals(exerciseId, sprint);
  }

  Future<void> replaceSprintIntervals({
    required int id,
    required List<LoggedInterval> intervals,
  }) async {
    final sprint = _cleanIntervals(intervals);
    await _db.transaction(() async {
      final updated =
          await (_db.update(
            _db.workoutExercises,
          )..where((row) => row.id.equals(id))).write(
            WorkoutExercisesCompanion(
              sets: Value(sprint.length),
              reps: const Value(1),
            ),
          );
      if (updated == 0) {
        throw ArgumentError('That exercise is gone.');
      }
      await (_db.delete(
        _db.sprintIntervalTargets,
      )..where((row) => row.workoutExerciseId.equals(id))).go();
      await _writeIntervals(id, sprint);
    });
  }

  Future<void> updateExercise({
    required int id,
    required int sets,
    required int reps,
    double? targetWeightKg,
    int? targetDurationSeconds,
    double? targetSpeedKmh,
    int? restSeconds,
    WeightIncrement? increment,
    bool saveWeight = false,
    bool saveJog = false,
    bool saveRest = false,
    bool saveIncrement = false,
  }) async {
    _requireCount(sets, 'sets');
    _requireCount(reps, 'reps');
    if (saveRest && restSeconds != null && restSeconds < 0) {
      throw ArgumentError('Enter the rest.');
    }
    final step = !saveIncrement || increment == null
        ? null
        : _requireIncrement(increment);
    final updated =
        await (_db.update(
          _db.workoutExercises,
        )..where((row) => row.id.equals(id))).write(
          WorkoutExercisesCompanion(
            sets: Value(sets),
            reps: Value(reps),
            targetWeightKg: saveWeight
                ? Value(_requireWeight(targetWeightKg))
                : const Value.absent(),
            targetMinutes: saveJog
                ? Value(_requireDuration(targetDurationSeconds))
                : const Value.absent(),
            targetSpeedKmh: saveJog
                ? Value(_requireSpeed(targetSpeedKmh))
                : const Value.absent(),
            restSeconds: saveRest ? Value(restSeconds) : const Value.absent(),
            incrementAmount: saveIncrement
                ? Value(step?.amount)
                : const Value.absent(),
            incrementUnit: saveIncrement
                ? Value(step?.unit.storageKey)
                : const Value.absent(),
          ),
        );
    if (updated == 0) {
      throw ArgumentError('That exercise is gone.');
    }
  }

  Future<void> removeExercise(int id) async {
    await (_db.delete(
      _db.sprintIntervalTargets,
    )..where((row) => row.workoutExerciseId.equals(id))).go();
    await (_db.delete(
      _db.workoutExercises,
    )..where((row) => row.id.equals(id))).go();
  }

  Future<void> setRestSeconds(int id, int seconds) async {
    if (seconds < 0) {
      throw ArgumentError('Enter the rest.');
    }
    final updated =
        await (_db.update(_db.routines)..where((row) => row.id.equals(id)))
            .write(RoutinesCompanion(restSeconds: Value(seconds)));
    if (updated == 0) {
      throw ArgumentError('That routine is gone.');
    }
  }

  Future<void> setIncrement(int id, WeightIncrement increment) async {
    final step = _requireIncrement(increment);
    final updated =
        await (_db.update(
          _db.routines,
        )..where((row) => row.id.equals(id))).write(
          RoutinesCompanion(
            incrementAmount: Value(step.amount),
            incrementUnit: Value(step.unit.storageKey),
            incrementsEnabled: Value(step.amount > 0),
          ),
        );
    if (updated == 0) {
      throw ArgumentError('That routine is gone.');
    }
  }

  Future<void> convertToDynamic(int id) {
    return setRoutineKind(id, RoutineKind.dynamicDay);
  }

  /// Switches among static, dynamic, and custom pattern. Workouts stay.
  /// Leaving a pattern turns its first seven steps into the week.
  Future<void> setRoutineKind(int id, RoutineKind kind) async {
    final routine = await (_db.select(
      _db.routines,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (routine == null) {
      throw ArgumentError('That routine is gone.');
    }
    final current = RoutineKind.fromStorage(routine.kind);
    if (current == kind) {
      return;
    }
    await _db.transaction(() async {
      if (current == RoutineKind.customPattern) {
        await _weekFromPattern(id);
      }
      final String? anchor;
      if (kind == RoutineKind.customPattern) {
        anchor =
            routine.anchorMonday ?? formatIsoDate(dateOnly(DateTime.now()));
      } else if (current == RoutineKind.customPattern) {
        anchor = null;
      } else {
        anchor = routine.anchorMonday;
      }
      final updated =
          await (_db.update(
            _db.routines,
          )..where((row) => row.id.equals(id))).write(
            RoutinesCompanion(
              kind: Value(kind.storageKey),
              anchorMonday: Value(anchor),
            ),
          );
      if (updated == 0) {
        throw ArgumentError('That routine is gone.');
      }
    });
  }

  Future<void> _weekFromPattern(int routineId) async {
    final rows = await (_db.select(
      _db.routineWeekdays,
    )..where((row) => row.routineId.equals(routineId))).get();
    final byDay = {for (final row in rows) row.weekday: row};
    await (_db.delete(
      _db.routineWeekdays,
    )..where((row) => row.routineId.equals(routineId))).go();
    for (var weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++) {
      final previous = byDay[weekday];
      await _db
          .into(_db.routineWeekdays)
          .insert(
            RoutineWeekdaysCompanion.insert(
              routineId: routineId,
              weekday: weekday,
              isRest: previous?.isRest ?? true,
              workoutId: Value(previous?.workoutId),
            ),
          );
    }
  }

  Future<void> pickWorkout({
    required int routineId,
    required DateTime day,
    required int workoutId,
  }) async {
    final workout = await (_db.select(
      _db.workouts,
    )..where((row) => row.id.equals(workoutId))).getSingleOrNull();
    if (workout == null || workout.routineId != routineId) {
      throw ArgumentError('That workout is not in this routine.');
    }
    await _db
        .into(_db.dayPicks)
        .insertOnConflictUpdate(
          DayPicksCompanion.insert(
            routineId: routineId,
            day: formatIsoDate(day),
            workoutId: workoutId,
          ),
        );
  }

  Future<String> exportRoutine(int id) async {
    await loadCatalog();
    final details = await routineDetails(id);
    final workouts = <TemplateWorkout>[];
    for (final summary in details.workouts) {
      final workout = await workoutDetails(summary.id);
      workouts.add(
        TemplateWorkout(
          name: workout.name,
          exercises: [
            for (final exercise in workout.exercises)
              TemplateExercise(
                exercise: exercise.exercise,
                sets: exercise.sets,
                reps: exercise.reps,
                targetWeightKg: exercise.targetWeightKg,
                targetDurationSeconds: exercise.targetDurationSeconds,
                targetSpeedKmh: exercise.targetSpeedKmh,
                restSeconds: exercise.restSeconds,
                increment: exercise.increment,
                intervals: [
                  for (final interval in exercise.intervals)
                    TemplateInterval(
                      speedKmh: interval.speedKmh,
                      durationSeconds: interval.durationSeconds,
                      unit: interval.unit,
                    ),
                ],
              ),
          ],
        ),
      );
    }
    final names = {
      for (final workout in details.workouts) workout.id: workout.name,
    };
    final slots = await trainingSlots(id);
    final custom = <String, Exercise>{};
    void take(Exercise exercise) {
      if (exercise.custom) {
        custom[exercise.storageKey] = exercise;
      }
    }

    for (final workout in workouts) {
      for (final exercise in workout.exercises) {
        take(exercise.exercise);
      }
    }
    for (final exercise in details.startWeightsKg.keys) {
      take(exercise);
    }
    final customExercises = custom.values.toList()
      ..sort((a, b) => a.storageKey.compareTo(b.storageKey));
    return encodeTemplate(
      TemplateFile(
        name: details.name,
        kind: details.kind,
        increment: details.increment,
        restSeconds: details.restSeconds,
        anchorMonday: details.anchorMonday == null
            ? null
            : formatIsoDate(details.anchorMonday!),
        startWeightsKg: details.startWeightsKg,
        customExercises: customExercises,
        weekdays: [
          for (final day in details.days)
            TemplateWeekday(
              weekday: day.weekday,
              isRest: day.isRest,
              workoutName: day.workoutName,
            ),
        ],
        workouts: workouts,
        slots: [
          for (final slot in slots)
            if (names.containsKey(slot.workoutId)) names[slot.workoutId]!,
        ],
        patternStart: details.patternStart == null
            ? null
            : formatIsoDate(details.patternStart!),
        pattern: [
          for (final day in details.pattern)
            TemplatePatternDay(
              position: day.position,
              isRest: day.isRest,
              workoutName: day.workoutName,
            ),
        ],
      ),
    );
  }

  Future<int> importRoutine(String source) async {
    await loadCatalog();
    final file = decodeTemplate(source);
    return _db.transaction(() async {
      for (final exercise in file.customExercises) {
        await _ensureCustom(exercise);
      }
      final id = await createRoutine(
        file.name,
        kind: file.kind,
        increment: file.increment,
        restSeconds: file.restSeconds,
        anchorMonday: file.anchorMonday == null
            ? null
            : parseIsoDate(file.anchorMonday!),
        patternStart: file.patternStart == null
            ? null
            : parseIsoDate(file.patternStart!),
      );
      final idsByName = <String, int>{};
      for (final workout in file.workouts) {
        final workoutId = await createWorkout(
          routineId: id,
          name: workout.name,
        );
        idsByName[workout.name] = workoutId;
        for (final exercise in workout.exercises) {
          await addExercise(
            workoutId: workoutId,
            exercise: exercise.exercise,
            sets: exercise.sets,
            reps: exercise.reps,
            targetWeightKg: exercise.targetWeightKg,
            targetDurationSeconds: exercise.targetDurationSeconds,
            targetSpeedKmh: exercise.targetSpeedKmh,
            restSeconds: exercise.restSeconds,
            increment: exercise.increment,
            intervals: [
              for (final interval in exercise.intervals)
                LoggedInterval(
                  speedKmh: interval.speedKmh,
                  durationSeconds: interval.durationSeconds,
                  unit: interval.unit,
                ),
            ],
          );
        }
      }
      for (final day in file.weekdays) {
        final linked = day.workoutName == null
            ? null
            : idsByName[day.workoutName!];
        await setWeekday(
          routineId: id,
          weekday: day.weekday,
          isRest: day.isRest,
          workoutId: day.isRest ? null : linked,
        );
      }
      for (final entry in file.startWeightsKg.entries) {
        await _db
            .into(_db.exerciseStarts)
            .insert(
              ExerciseStartsCompanion.insert(
                routineId: id,
                exercise: entry.key,
                startWeightKg: roundKg(entry.value),
              ),
            );
      }
      for (var index = 0; index < file.slots.length; index++) {
        final workoutId = idsByName[file.slots[index]];
        if (workoutId == null) {
          throw ArgumentError('That file is not a template.');
        }
        await _db
            .into(_db.trainingSlots)
            .insert(
              TrainingSlotsCompanion.insert(
                routineId: id,
                sequenceIndex: index,
                workoutId: workoutId,
              ),
            );
      }
      for (var index = 0; index < file.pattern.length; index++) {
        final day = file.pattern[index];
        await addPatternDay(id);
        final linked = day.workoutName == null
            ? null
            : idsByName[day.workoutName!];
        await setPatternDay(
          routineId: id,
          position: index + 1,
          isRest: day.isRest,
          workoutId: day.isRest ? null : linked,
        );
      }
      return id;
    });
  }

  Future<List<RoutineExerciseProgress>> routineProgress(int routineId) async {
    final rows = await _db
        .customSelect(
          '''
          SELECT we.exercise AS exercise, we.reps AS reps
          FROM workout_exercises we
          INNER JOIN workouts w ON w.id = we.workout_id
          WHERE w.routine_id = ?
          ORDER BY w.position, we.position, we.exercise
          ''',
          variables: [Variable.withInt(routineId)],
        )
        .get();
    final streams = <({Exercise exercise, int? targetReps})>[];
    final seen = <String>{};
    for (final row in rows) {
      final exercise = Exercise.fromStorage(row.read<String>('exercise'));
      final reps = exercise.kind == ExerciseKind.strength
          ? row.read<int>('reps')
          : null;
      if (seen.add('${exercise.storageKey}|$reps')) {
        streams.add((exercise: exercise, targetReps: reps));
      }
    }
    final counts = <Exercise, int>{};
    for (final stream in streams) {
      counts[stream.exercise] = (counts[stream.exercise] ?? 0) + 1;
    }
    final progressRows = <RoutineExerciseProgress>[];
    for (final stream in streams) {
      final progress = await exerciseProgress(
        routineId,
        stream.exercise,
        targetReps: stream.targetReps,
      );
      final series = progress.series.isEmpty ? null : progress.series.first;
      final latest = series == null || series.points.isEmpty
          ? null
          : series.points.last;
      final alone = (counts[stream.exercise] ?? 0) < 2;
      progressRows.add(
        RoutineExerciseProgress(
          exercise: stream.exercise,
          targetReps: stream.targetReps,
          title: alone || stream.targetReps == null
              ? stream.exercise.label
              : '${stream.exercise.label} · ${stream.targetReps} reps',
          sessions: series?.points.length ?? 0,
          latestLabel: latest == null
              ? null
              : _formatProgress(latest.value, series!.unit),
        ),
      );
    }
    return progressRows;
  }

  Future<ExerciseProgress> exerciseProgress(
    int routineId,
    Exercise exercise, {
    int? targetReps,
  }) async {
    final rows = await _db
        .customSelect(
          '''
          SELECT s.logged_on AS logged_on,
                 el.weight_kg AS weight_kg,
                 MAX(sl.speed_kmh) AS peak_speed,
                 MAX(CASE WHEN sl.set_index = 0 THEN sl.speed_kmh END) AS first_speed,
                 MAX(CASE WHEN sl.set_index = 0 THEN sl.duration_seconds END)
                   AS first_duration
          FROM exercise_logs el
          INNER JOIN sessions s ON s.id = el.session_id
          LEFT JOIN set_logs sl ON sl.exercise_log_id = el.id
          WHERE s.routine_id = ?
            AND el.exercise = ?
            ${targetReps == null ? '' : 'AND (el.target_reps = ? OR el.target_reps IS NULL)'}
          GROUP BY el.id
          ORDER BY s.logged_on ASC, el.id ASC
          ''',
          variables: [
            Variable.withInt(routineId),
            Variable.withString(exercise.storageKey),
            if (targetReps != null) Variable.withInt(targetReps),
          ],
        )
        .get();
    final days = [
      for (final row in rows) parseIsoDate(row.read<String>('logged_on')),
    ];
    return switch (exercise.kind) {
      ExerciseKind.strength => ExerciseProgress(
        exercise: exercise,
        series: [
          ProgressSeries(
            label: 'Weight',
            unit: 'kg',
            points: [
              for (var index = 0; index < rows.length; index++)
                ProgressPoint(
                  day: days[index],
                  value: _asDouble(rows[index].data['weight_kg']),
                ),
            ],
          ),
        ],
      ),
      ExerciseKind.jogging => ExerciseProgress(
        exercise: exercise,
        series: [
          ProgressSeries(
            label: 'Speed',
            unit: 'km/h',
            points: _optionalPoints(rows, days, 'first_speed'),
          ),
          ProgressSeries(
            label: 'Minutes',
            unit: 'min',
            points: [
              for (var index = 0; index < rows.length; index++)
                if (rows[index].data['first_duration'] != null)
                  ProgressPoint(
                    day: days[index],
                    value: _asInt(rows[index].data['first_duration']) / 60,
                  ),
            ],
          ),
        ],
      ),
      ExerciseKind.sprinting => ExerciseProgress(
        exercise: exercise,
        series: [
          ProgressSeries(
            label: 'Peak speed',
            unit: 'km/h',
            points: _optionalPoints(rows, days, 'peak_speed'),
          ),
        ],
      ),
    };
  }

  Future<List<({int sequenceIndex, int workoutId})>> trainingSlots(
    int routineId,
  ) async {
    final rows =
        await (_db.select(_db.trainingSlots)
              ..where((row) => row.routineId.equals(routineId))
              ..orderBy([(row) => OrderingTerm.asc(row.sequenceIndex)]))
            .get();
    return [
      for (final row in rows)
        (sequenceIndex: row.sequenceIndex, workoutId: row.workoutId),
    ];
  }

  Future<double?> prescribedWeight({
    required int routineId,
    required Exercise exercise,
    required DateTime day,
    int? targetReps,
    double? targetWeightKg,
    WeightIncrement? increment,
  }) async {
    final step = increment ?? await _routineIncrement(routineId);
    final start = targetWeightKg ?? await _startWeight(routineId, exercise);
    final previous = await _previousLog(
      routineId: routineId,
      exercise: exercise,
      beforeIso: formatIsoDate(day),
      targetReps: targetReps,
    );
    return prescribe(
      previousWeightKg: previous?.weightKg,
      previousReps: previous?.totalReps,
      startWeightKg: start,
      increment: step,
    );
  }

  Future<WeightIncrement> _routineIncrement(int routineId) async {
    final routine = await (_db.select(
      _db.routines,
    )..where((row) => row.id.equals(routineId))).getSingle();
    return WeightIncrement(
      unit: IncrementUnit.fromStorage(routine.incrementUnit),
      amount: routine.incrementAmount,
    );
  }

  Future<void> logSession({
    required int routineId,
    required DateTime loggedOn,
    required int workoutId,
    int? trainingSlotId,
    required List<LoggedLift> lifts,
  }) {
    final seen = <Exercise>{};
    final cleanLifts = <LoggedLift>[];
    for (final lift in lifts) {
      if (!seen.add(lift.exercise)) {
        throw ArgumentError('Each exercise is logged once.');
      }
      cleanLifts.add(_cleanLift(lift));
    }

    final iso = formatIsoDate(loggedOn);
    return _db.transaction(() async {
      final workout = await (_db.select(
        _db.workouts,
      )..where((row) => row.id.equals(workoutId))).getSingleOrNull();
      if (workout == null || workout.routineId != routineId) {
        throw ArgumentError('That workout is not in this routine.');
      }
      if (trainingSlotId != null) {
        final slot = await (_db.select(
          _db.trainingSlots,
        )..where((row) => row.id.equals(trainingSlotId))).getSingleOrNull();
        if (slot == null ||
            slot.routineId != routineId ||
            slot.workoutId != workoutId) {
          throw ArgumentError('That training day is not in this routine.');
        }
      }

      final existing = await _sessionOn(routineId, iso);
      if (existing != null) {
        await _deleteSession(existing.id);
      }
      final sessionId = await _db
          .into(_db.sessions)
          .insert(
            SessionsCompanion.insert(
              routineId: routineId,
              loggedOn: iso,
              trainingSlotId: Value(trainingSlotId),
              workoutId: workoutId,
            ),
          );
      for (final lift in cleanLifts) {
        final logId = await _db
            .into(_db.exerciseLogs)
            .insert(
              ExerciseLogsCompanion.insert(
                sessionId: sessionId,
                exercise: lift.exercise,
                weightKg: lift.weightKg,
                targetReps: Value(lift.targetReps),
              ),
            );
        switch (lift.exercise.kind) {
          case ExerciseKind.strength:
            for (var index = 0; index < lift.reps.length; index++) {
              await _db
                  .into(_db.setLogs)
                  .insert(
                    SetLogsCompanion.insert(
                      exerciseLogId: logId,
                      setIndex: index,
                      reps: lift.reps[index],
                      weightKg: Value(
                        lift.setWeights != null &&
                                index < lift.setWeights!.length &&
                                lift.setWeights![index] != null
                            ? lift.setWeights![index]!
                            : lift.weightKg,
                      ),
                    ),
                  );
            }
          case ExerciseKind.jogging:
            await _db
                .into(_db.setLogs)
                .insert(
                  SetLogsCompanion.insert(
                    exerciseLogId: logId,
                    setIndex: 0,
                    reps: 0,
                    speedKmh: Value(lift.speedKmh),
                    durationSeconds: Value(lift.durationSeconds),
                    durationUnit: const Value<String?>('min'),
                  ),
                );
          case ExerciseKind.sprinting:
            for (var index = 0; index < lift.intervals.length; index++) {
              final interval = lift.intervals[index];
              await _db
                  .into(_db.setLogs)
                  .insert(
                    SetLogsCompanion.insert(
                      exerciseLogId: logId,
                      setIndex: index,
                      reps: 0,
                      speedKmh: Value(interval.speedKmh),
                      durationSeconds: Value(interval.durationSeconds),
                      durationUnit: Value<String?>(interval.unit.storageKey),
                    ),
                  );
            }
        }
      }
    });
  }

  Future<void> saveStrengthSet({
    required int routineId,
    required DateTime loggedOn,
    required int workoutId,
    int? trainingSlotId,
    required Exercise exercise,
    required int targetReps,
    required int setIndex,
    required double weightKg,
    required int reps,
  }) {
    if (exercise.kind != ExerciseKind.strength) {
      throw ArgumentError('That exercise is not a strength set.');
    }
    if (setIndex < 0 || reps < 0) {
      throw ArgumentError('Enter reps for every set.');
    }
    if (weightKg < 0 || weightKg.isNaN || weightKg.isInfinite) {
      throw ArgumentError('Enter a weight for every exercise.');
    }
    final cleanWeight = roundKg(weightKg);
    final iso = formatIsoDate(loggedOn);
    return _db.transaction(() async {
      final sessionId = await _ensureSession(
        routineId: routineId,
        iso: iso,
        workoutId: workoutId,
        trainingSlotId: trainingSlotId,
      );
      final logId = await _ensureExerciseLog(
        sessionId: sessionId,
        exercise: exercise,
        weightKg: cleanWeight,
        targetReps: targetReps,
      );
      await (_db.delete(_db.setLogs)..where(
            (row) =>
                row.exerciseLogId.equals(logId) & row.setIndex.equals(setIndex),
          ))
          .go();
      await _db
          .into(_db.setLogs)
          .insert(
            SetLogsCompanion.insert(
              exerciseLogId: logId,
              setIndex: setIndex,
              reps: reps,
              weightKg: Value(cleanWeight),
            ),
          );
      await _refreshExerciseWeight(logId);
    });
  }

  Future<void> clearStrengthSet({
    required int routineId,
    required DateTime loggedOn,
    required Exercise exercise,
    required int setIndex,
  }) {
    final iso = formatIsoDate(loggedOn);
    return _db.transaction(() async {
      final session = await _sessionOn(routineId, iso);
      if (session == null) {
        return;
      }
      final log =
          await (_db.select(_db.exerciseLogs)..where(
                (row) =>
                    row.sessionId.equals(session.id) &
                    row.exercise.equalsValue(exercise),
              ))
              .getSingleOrNull();
      if (log == null) {
        return;
      }
      await (_db.delete(_db.setLogs)..where(
            (row) =>
                row.exerciseLogId.equals(log.id) &
                row.setIndex.equals(setIndex),
          ))
          .go();
      final remaining = await (_db.select(
        _db.setLogs,
      )..where((row) => row.exerciseLogId.equals(log.id))).get();
      if (remaining.isEmpty) {
        await (_db.delete(
          _db.exerciseLogs,
        )..where((row) => row.id.equals(log.id))).go();
        final others = await (_db.select(
          _db.exerciseLogs,
        )..where((row) => row.sessionId.equals(session.id))).get();
        if (others.isEmpty) {
          await (_db.delete(
            _db.sessions,
          )..where((row) => row.id.equals(session.id))).go();
        }
      } else {
        await _refreshExerciseWeight(log.id);
      }
    });
  }

  /// Writes jogging and sprint logs without removing strength sets.
  Future<void> saveLifts({
    required int routineId,
    required DateTime loggedOn,
    required int workoutId,
    int? trainingSlotId,
    required List<LoggedLift> lifts,
  }) {
    final seen = <Exercise>{};
    final cleanLifts = <LoggedLift>[];
    for (final lift in lifts) {
      if (lift.exercise.kind == ExerciseKind.strength) {
        continue;
      }
      if (!seen.add(lift.exercise)) {
        throw ArgumentError('Each exercise is logged once.');
      }
      cleanLifts.add(_cleanLift(lift));
    }
    final iso = formatIsoDate(loggedOn);
    return _db.transaction(() async {
      final sessionId = await _ensureSession(
        routineId: routineId,
        iso: iso,
        workoutId: workoutId,
        trainingSlotId: trainingSlotId,
      );
      for (final lift in cleanLifts) {
        final existing =
            await (_db.select(_db.exerciseLogs)..where(
                  (row) =>
                      row.sessionId.equals(sessionId) &
                      row.exercise.equalsValue(lift.exercise),
                ))
                .getSingleOrNull();
        if (existing != null) {
          await (_db.delete(
            _db.setLogs,
          )..where((row) => row.exerciseLogId.equals(existing.id))).go();
          await (_db.delete(
            _db.exerciseLogs,
          )..where((row) => row.id.equals(existing.id))).go();
        }
        final logId = await _db
            .into(_db.exerciseLogs)
            .insert(
              ExerciseLogsCompanion.insert(
                sessionId: sessionId,
                exercise: lift.exercise,
                weightKg: lift.weightKg,
                targetReps: Value(lift.targetReps),
              ),
            );
        switch (lift.exercise.kind) {
          case ExerciseKind.strength:
            break;
          case ExerciseKind.jogging:
            await _db
                .into(_db.setLogs)
                .insert(
                  SetLogsCompanion.insert(
                    exerciseLogId: logId,
                    setIndex: 0,
                    reps: 0,
                    speedKmh: Value(lift.speedKmh),
                    durationSeconds: Value(lift.durationSeconds),
                    durationUnit: const Value<String?>('min'),
                  ),
                );
          case ExerciseKind.sprinting:
            for (var index = 0; index < lift.intervals.length; index++) {
              final interval = lift.intervals[index];
              await _db
                  .into(_db.setLogs)
                  .insert(
                    SetLogsCompanion.insert(
                      exerciseLogId: logId,
                      setIndex: index,
                      reps: 0,
                      speedKmh: Value(interval.speedKmh),
                      durationSeconds: Value(interval.durationSeconds),
                      durationUnit: Value<String?>(interval.unit.storageKey),
                    ),
                  );
            }
        }
      }
    });
  }

  Future<int> _ensureSession({
    required int routineId,
    required String iso,
    required int workoutId,
    int? trainingSlotId,
  }) async {
    final workout = await (_db.select(
      _db.workouts,
    )..where((row) => row.id.equals(workoutId))).getSingleOrNull();
    if (workout == null || workout.routineId != routineId) {
      throw ArgumentError('That workout is not in this routine.');
    }
    if (trainingSlotId != null) {
      final slot = await (_db.select(
        _db.trainingSlots,
      )..where((row) => row.id.equals(trainingSlotId))).getSingleOrNull();
      if (slot == null ||
          slot.routineId != routineId ||
          slot.workoutId != workoutId) {
        throw ArgumentError('That training day is not in this routine.');
      }
    }
    final existing = await _sessionOn(routineId, iso);
    if (existing != null) {
      return existing.id;
    }
    return _db
        .into(_db.sessions)
        .insert(
          SessionsCompanion.insert(
            routineId: routineId,
            loggedOn: iso,
            trainingSlotId: Value(trainingSlotId),
            workoutId: workoutId,
          ),
        );
  }

  Future<int> _ensureExerciseLog({
    required int sessionId,
    required Exercise exercise,
    required double weightKg,
    required int targetReps,
  }) async {
    final existing =
        await (_db.select(_db.exerciseLogs)..where(
              (row) =>
                  row.sessionId.equals(sessionId) &
                  row.exercise.equalsValue(exercise),
            ))
            .getSingleOrNull();
    if (existing != null) {
      return existing.id;
    }
    return _db
        .into(_db.exerciseLogs)
        .insert(
          ExerciseLogsCompanion.insert(
            sessionId: sessionId,
            exercise: exercise,
            weightKg: weightKg,
            targetReps: Value(targetReps),
          ),
        );
  }

  Future<void> _refreshExerciseWeight(int logId) async {
    final sets =
        await (_db.select(_db.setLogs)
              ..where((row) => row.exerciseLogId.equals(logId))
              ..orderBy([(row) => OrderingTerm.desc(row.setIndex)]))
            .get();
    if (sets.isEmpty) {
      return;
    }
    final weight = sets.first.weightKg;
    if (weight == null) {
      return;
    }
    await (_db.update(_db.exerciseLogs)..where((row) => row.id.equals(logId)))
        .write(ExerciseLogsCompanion(weightKg: Value(weight)));
  }

  Future<List<LoggedLift>> sessionLifts(int routineId, DateTime day) async {
    final session = await _sessionOn(routineId, formatIsoDate(day));
    if (session == null) {
      return const [];
    }
    final logs = await (_db.select(
      _db.exerciseLogs,
    )..where((row) => row.sessionId.equals(session.id))).get();
    final lifts = <LoggedLift>[];
    for (final log in logs) {
      final sets =
          await (_db.select(_db.setLogs)
                ..where((row) => row.exerciseLogId.equals(log.id))
                ..orderBy([(row) => OrderingTerm.asc(row.setIndex)]))
              .get();
      lifts.add(_liftFrom(log.exercise, log.weightKg, sets, log.targetReps));
    }
    return lifts;
  }

  Future<List<PlanDay>> planDays(int routineId, DateTime now) async {
    final routine = await routineDetails(routineId);
    final today = dateOnly(now);
    final loggedOn = await _loggedIsoDates(routineId);
    if (routine.isPattern) {
      return _patternPlanDays(routine, today, loggedOn);
    }
    final names = {
      for (final workout in routine.workouts) workout.id: workout.name,
    };
    final byWeekday = {for (final day in routine.days) day.weekday: day};
    final slotWorkouts = <int, int>{};
    if (routine.anchorMonday != null) {
      for (final slot in await trainingSlots(routineId)) {
        slotWorkouts[slot.sequenceIndex] = slot.workoutId;
      }
    }

    final dates = routine.anchorMonday == null
        ? [
            for (var offset = 0; offset < 7; offset++)
              addCalendarDays(
                addCalendarDays(today, DateTime.monday - today.weekday),
                offset,
              ),
          ]
        : [
            for (var offset = 0; offset < templateLengthDays; offset++)
              addCalendarDays(routine.anchorMonday!, offset),
          ];

    return [
      for (final date in dates)
        _planDay(
          routine: routine,
          date: date,
          today: today,
          weekday: byWeekday[date.weekday],
          names: names,
          slotWorkouts: slotWorkouts,
          logged: loggedOn.contains(formatIsoDate(date)),
        ),
    ];
  }

  PlanDay _planDay({
    required RoutineDetails routine,
    required DateTime date,
    required DateTime today,
    required WeekdayRow? weekday,
    required Map<int, String> names,
    required Map<int, int> slotWorkouts,
    required bool logged,
  }) {
    final isToday = date == today;
    var isRest = true;
    var needsWorkout = false;
    int? workoutId;

    if (weekday != null && routine.anchorMonday != null) {
      if (templateWindow(routine.anchorMonday!, date) ==
              TemplateWindow.inside &&
          !weekday.isRest) {
        isRest = false;
        workoutId = weekday.workoutId;
        if (workoutId == null) {
          final sequence = templateSequenceIndex(routine.anchorMonday!, date);
          workoutId = sequence == null ? null : slotWorkouts[sequence];
          if (workoutId == null) {
            isRest = true;
          }
        }
      }
    } else if (weekday != null && !weekday.isRest) {
      isRest = false;
      workoutId = weekday.workoutId;
      needsWorkout = workoutId == null;
    }

    final workoutName = workoutId == null ? null : names[workoutId];
    return PlanDay(
      date: date,
      isToday: isToday,
      isRest: isRest,
      needsWorkout: needsWorkout,
      workoutName: workoutName,
      shortLabel: planShortLabel(
        isRest: isRest,
        needsWorkout: needsWorkout,
        workoutName: workoutName,
      ),
      logged: logged && !isRest,
      canLog: isToday && workoutId != null,
    );
  }

  List<PlanDay> _patternPlanDays(
    RoutineDetails routine,
    DateTime today,
    Set<String> loggedOn,
  ) {
    final monday = addCalendarDays(today, DateTime.monday - today.weekday);
    final dates = [
      for (var offset = 0; offset < templateLengthDays; offset++)
        addCalendarDays(monday, offset),
    ];
    return [
      for (final date in dates)
        _patternPlanDay(
          routine: routine,
          date: date,
          today: today,
          logged: loggedOn.contains(formatIsoDate(date)),
        ),
    ];
  }

  PlanDay _patternPlanDay({
    required RoutineDetails routine,
    required DateTime date,
    required DateTime today,
    required bool logged,
  }) {
    final isToday = date == today;
    final step = routine.stepOn(date);
    if (step == null) {
      return PlanDay(
        date: date,
        isToday: isToday,
        isRest: false,
        needsWorkout: true,
        workoutName: null,
        shortLabel: '?',
        logged: false,
        canLog: false,
      );
    }
    final needsWorkout = !step.isRest && step.workoutId == null;
    final workoutName = step.isRest || needsWorkout
        ? null
        : (step.workoutName ?? 'Workout');
    return PlanDay(
      date: date,
      isToday: isToday,
      isRest: step.isRest,
      needsWorkout: needsWorkout,
      workoutName: workoutName,
      shortLabel: patternCalendarLabel(
        isRest: step.isRest,
        needsWorkout: needsWorkout,
        workoutName: step.workoutName,
      ),
      logged: logged && workoutName != null,
      canLog: isToday && workoutName != null,
    );
  }

  Future<Set<String>> _loggedIsoDates(int routineId) async {
    final rows = await (_db.select(
      _db.sessions,
    )..where((row) => row.routineId.equals(routineId))).get();
    return {for (final row in rows) row.loggedOn};
  }

  Future<HomeData> loadHome(DateTime now, {int? routineId}) async {
    final day = dateOnly(now);
    final id = routineId ?? await currentRoutineId();
    if (id == null) {
      return HomeData(
        day: day,
        routineId: null,
        routineName: null,
        today: const TodayNone(),
      );
    }
    final routine = await routineDetails(id);
    return HomeData(
      day: day,
      routineId: routine.id,
      routineName: routine.name,
      today: await _resolveToday(routine, day),
      kind: routine.kind,
    );
  }

  Future<TodayView> loadDay(int routineId, DateTime day) async {
    final routine = await routineDetails(routineId);
    return _resolveToday(routine, dateOnly(day));
  }

  Future<LogFormData?> loadLogForm(DateTime now, {int? routineId}) async {
    final home = await loadHome(now, routineId: routineId);
    final today = home.today;
    if (today is! TodayWorkout || home.routineId == null) {
      return null;
    }
    final logs = await sessionLifts(home.routineId!, home.day);
    final assigned = _assignLogs(today.exercises, logs);
    return LogFormData(
      routineId: home.routineId!,
      workoutId: today.workoutId,
      trainingSlotId: today.trainingSlotId,
      day: home.day,
      workoutName: today.workoutName,
      updating: logs.isNotEmpty,
      exercises: [
        for (var index = 0; index < today.exercises.length; index++)
          _seedExercise(
            today.exercises[index],
            assigned[index],
            substitute:
                assigned[index] != null &&
                    assigned[index]!.exercise != today.exercises[index].exercise
                ? assigned[index]!.exercise
                : null,
          ),
      ],
    );
  }

  List<LoggedLift?> _assignLogs(
    List<PrescribedExercise> planned,
    List<LoggedLift> logs,
  ) {
    final unused = [...logs];
    final assigned = List<LoggedLift?>.filled(planned.length, null);
    for (var index = 0; index < planned.length; index++) {
      final match = unused.indexWhere(
        (lift) => lift.exercise == planned[index].exercise,
      );
      if (match >= 0) {
        assigned[index] = unused.removeAt(match);
      }
    }
    for (var index = 0; index < planned.length; index++) {
      if (assigned[index] != null) {
        continue;
      }
      final exercise = planned[index];
      final match = unused.indexWhere(
        (lift) =>
            lift.exercise.kind == exercise.exercise.kind &&
            (lift.targetReps == null || lift.targetReps == exercise.reps),
      );
      if (match >= 0) {
        assigned[index] = unused.removeAt(match);
      }
    }
    return assigned;
  }

  Future<TodayView> _resolveToday(RoutineDetails routine, DateTime day) async {
    if (routine.isPattern) {
      return _resolvePattern(routine, day);
    }
    if (routine.isDynamic) {
      return _resolveDynamic(routine, day);
    }
    WeekdayRow? weekday;
    for (final row in routine.days) {
      if (row.weekday == day.weekday) {
        weekday = row;
        break;
      }
    }
    if (weekday == null) {
      return const TodayRest();
    }

    if (routine.anchorMonday != null) {
      if (templateWindow(routine.anchorMonday!, day) != TemplateWindow.inside) {
        return const TodayNoSession();
      }
      if (weekday.isRest) {
        return const TodayRest();
      }
      if (weekday.workoutId != null) {
        return _workoutToday(
          routine: routine,
          workoutId: weekday.workoutId!,
          day: day,
        );
      }
      final sequence = templateSequenceIndex(routine.anchorMonday!, day);
      if (sequence == null) {
        return const TodayRest();
      }
      final slot =
          await (_db.select(_db.trainingSlots)..where(
                (row) =>
                    row.routineId.equals(routine.id) &
                    row.sequenceIndex.equals(sequence),
              ))
              .getSingle();
      return _workoutToday(
        routine: routine,
        workoutId: slot.workoutId,
        day: day,
        trainingSlotId: slot.id,
      );
    }

    if (weekday.isRest) {
      return const TodayRest();
    }
    if (weekday.workoutId == null) {
      return const TodayNeedsWorkout();
    }
    return _workoutToday(
      routine: routine,
      workoutId: weekday.workoutId!,
      day: day,
    );
  }

  Future<TodayView> _resolvePattern(
    RoutineDetails routine,
    DateTime day,
  ) async {
    final step = routine.stepOn(day);
    if (step == null) {
      return const TodayNeedsWorkout();
    }
    if (step.isRest) {
      return const TodayRest();
    }
    if (step.workoutId == null) {
      return const TodayNeedsWorkout();
    }
    return _workoutToday(
      routine: routine,
      workoutId: step.workoutId!,
      day: day,
    );
  }

  Future<TodayView> _resolveDynamic(
    RoutineDetails routine,
    DateTime day,
  ) async {
    if (routine.workouts.isEmpty) {
      return const TodayNeedsWorkout();
    }
    final iso = formatIsoDate(day);
    final session = await _sessionOn(routine.id, iso);
    final int workoutId;
    if (session != null) {
      workoutId = session.workoutId;
    } else {
      final pick =
          await (_db.select(_db.dayPicks)..where(
                (row) => row.routineId.equals(routine.id) & row.day.equals(iso),
              ))
              .getSingleOrNull();
      final picked = pick == null
          ? null
          : routine.workouts.where((workout) => workout.id == pick.workoutId);
      if (picked != null && picked.isNotEmpty) {
        workoutId = pick!.workoutId;
      } else {
        workoutId = await _suggestedWorkoutId(routine, day);
      }
    }
    return _workoutToday(
      routine: routine,
      workoutId: workoutId,
      day: day,
      choices: routine.workouts,
    );
  }

  Future<int> _suggestedWorkoutId(RoutineDetails routine, DateTime day) async {
    final rows = await _db
        .customSelect(
          '''
          SELECT workout_id AS workout_id
          FROM sessions
          WHERE routine_id = ? AND logged_on < ?
          ORDER BY logged_on DESC, id DESC
          LIMIT 1
          ''',
          variables: [
            Variable.withInt(routine.id),
            Variable.withString(formatIsoDate(day)),
          ],
        )
        .get();
    if (rows.isEmpty) {
      return routine.workouts.first.id;
    }
    final lastId = rows.first.read<int>('workout_id');
    final index = routine.workouts.indexWhere(
      (workout) => workout.id == lastId,
    );
    if (index < 0) {
      return routine.workouts.first.id;
    }
    return routine.workouts[(index + 1) % routine.workouts.length].id;
  }

  Future<TodayWorkout> _workoutToday({
    required RoutineDetails routine,
    required int workoutId,
    required DateTime day,
    int? trainingSlotId,
    List<WorkoutSummary> choices = const [],
  }) async {
    final workout = await workoutDetails(workoutId);
    final logged = await _sessionOn(routine.id, formatIsoDate(day));
    final exercises = <PrescribedExercise>[];
    for (final exercise in workout.exercises) {
      exercises.add(
        PrescribedExercise(
          exercise: exercise.exercise,
          sets: exercise.sets,
          reps: exercise.reps,
          weightKg: exercise.exercise.kind == ExerciseKind.strength
              ? await prescribedWeight(
                  routineId: routine.id,
                  exercise: exercise.exercise,
                  day: day,
                  targetReps: exercise.reps,
                  targetWeightKg: exercise.targetWeightKg,
                  increment: exercise.increment ?? routine.increment,
                )
              : null,
          targetDurationSeconds: exercise.targetDurationSeconds,
          targetSpeedKmh: exercise.targetSpeedKmh,
          restSeconds: exercise.restSeconds ?? routine.restSeconds,
          intervals: exercise.intervals,
        ),
      );
    }
    return TodayWorkout(
      workoutId: workout.id,
      workoutName: workout.name,
      trainingSlotId: trainingSlotId,
      logged: logged != null,
      exercises: exercises,
      choices: choices,
    );
  }

  Future<List<ActivityDay>> activityDays(int routineId, DateTime now) async {
    final today = dateOnly(now);
    final thisMonday = addCalendarDays(today, DateTime.monday - today.weekday);
    final start = addCalendarDays(thisMonday, -11 * 7);
    final end = addCalendarDays(thisMonday, 6);
    final rows = await _db
        .customSelect(
          '''
          SELECT s.logged_on AS logged_on, w.name AS workout_name
          FROM sessions s
          INNER JOIN workouts w ON w.id = s.workout_id
          WHERE s.routine_id = ?
            AND s.logged_on >= ?
            AND s.logged_on <= ?
          ''',
          variables: [
            Variable.withInt(routineId),
            Variable.withString(formatIsoDate(start)),
            Variable.withString(formatIsoDate(end)),
          ],
        )
        .get();
    final names = <String, String>{
      for (final row in rows)
        row.read<String>('logged_on'): row.read<String>('workout_name'),
    };
    final schedule = await _patternSchedule(routineId);
    final days = <ActivityDay>[];
    for (
      var date = start;
      !date.isAfter(end);
      date = addCalendarDays(date, 1)
    ) {
      final iso = formatIsoDate(date);
      final mark = _patternMark(schedule.start, schedule.steps, date);
      days.add(
        ActivityDay(
          date: date,
          logged: names.containsKey(iso),
          isToday: date == today,
          workoutName: names[iso],
          planName: mark?.name,
          planRest: mark?.rest ?? false,
          planNeedsWorkout: mark?.needsWorkout ?? false,
        ),
      );
    }
    return days;
  }

  Future<({DateTime? start, List<PatternDayRow> steps})> _patternSchedule(
    int routineId,
  ) async {
    final routine = await (_db.select(
      _db.routines,
    )..where((row) => row.id.equals(routineId))).getSingleOrNull();
    if (routine == null ||
        RoutineKind.fromStorage(routine.kind) != RoutineKind.customPattern ||
        routine.anchorMonday == null) {
      return (start: null, steps: const <PatternDayRow>[]);
    }
    final rows =
        await (_db.select(_db.routineWeekdays)
              ..where((row) => row.routineId.equals(routineId))
              ..orderBy([(row) => OrderingTerm.asc(row.weekday)]))
            .get();
    if (rows.isEmpty) {
      return (start: null, steps: const <PatternDayRow>[]);
    }
    final workouts = await (_db.select(
      _db.workouts,
    )..where((row) => row.routineId.equals(routineId))).get();
    final names = {for (final workout in workouts) workout.id: workout.name};
    return (
      start: parseIsoDate(routine.anchorMonday!),
      steps: [
        for (final row in rows)
          PatternDayRow(
            position: row.weekday,
            isRest: row.isRest,
            workoutId: row.workoutId,
            workoutName: row.workoutId == null ? null : names[row.workoutId],
          ),
      ],
    );
  }

  ({String? name, bool rest, bool needsWorkout})? _patternMark(
    DateTime? start,
    List<PatternDayRow> steps,
    DateTime date,
  ) {
    if (start == null || steps.isEmpty) {
      return null;
    }
    final step =
        steps[patternIndex(start: start, day: date, length: steps.length)];
    if (step.isRest) {
      return (name: null, rest: true, needsWorkout: false);
    }
    if (step.workoutId == null) {
      return (name: null, rest: false, needsWorkout: true);
    }
    return (
      name: step.workoutName ?? 'Workout',
      rest: false,
      needsWorkout: false,
    );
  }

  Future<int> _insertWorkout({
    required int routineId,
    required String name,
    required int position,
    required List<Exercise> exercises,
    Map<Exercise, double> targetWeightsKg = const {},
  }) async {
    final workoutId = await _db
        .into(_db.workouts)
        .insert(
          WorkoutsCompanion.insert(
            routineId: routineId,
            name: name,
            position: position,
          ),
        );
    for (var index = 0; index < exercises.length; index++) {
      await _db
          .into(_db.workoutExercises)
          .insert(
            WorkoutExercisesCompanion.insert(
              workoutId: workoutId,
              position: index,
              sets: 5,
              reps: 5,
              exercise: exercises[index],
              targetWeightKg: Value(targetWeightsKg[exercises[index]]),
            ),
          );
    }
    return workoutId;
  }

  Future<Session?> _sessionOn(int routineId, String iso) {
    return (_db.select(_db.sessions)..where(
          (row) => row.routineId.equals(routineId) & row.loggedOn.equals(iso),
        ))
        .getSingleOrNull();
  }

  Future<void> _deleteSession(int sessionId) async {
    final logs = await (_db.select(
      _db.exerciseLogs,
    )..where((row) => row.sessionId.equals(sessionId))).get();
    for (final log in logs) {
      await (_db.delete(
        _db.setLogs,
      )..where((row) => row.exerciseLogId.equals(log.id))).go();
    }
    await (_db.delete(
      _db.exerciseLogs,
    )..where((row) => row.sessionId.equals(sessionId))).go();
    await (_db.delete(
      _db.sessions,
    )..where((row) => row.id.equals(sessionId))).go();
  }

  Future<({double weightKg, int totalReps})?> _previousLog({
    required int routineId,
    required Exercise exercise,
    required String beforeIso,
    int? targetReps,
  }) async {
    final rows = await _db
        .customSelect(
          '''
          SELECT el.weight_kg AS weight_kg,
                 COALESCE(SUM(sl.reps), 0) AS total_reps
          FROM exercise_logs el
          INNER JOIN sessions s ON s.id = el.session_id
          LEFT JOIN set_logs sl ON sl.exercise_log_id = el.id
          WHERE s.routine_id = ?
            AND el.exercise = ?
            AND s.logged_on < ?
            ${targetReps == null ? '' : 'AND (el.target_reps = ? OR el.target_reps IS NULL)'}
          GROUP BY el.id
          ORDER BY s.logged_on DESC, s.id DESC
          LIMIT 1
          ''',
          variables: [
            Variable.withInt(routineId),
            Variable.withString(exercise.storageKey),
            Variable.withString(beforeIso),
            if (targetReps != null) Variable.withInt(targetReps),
          ],
        )
        .get();
    if (rows.isEmpty) {
      return null;
    }
    return (
      weightKg: _asDouble(rows.first.data['weight_kg']),
      totalReps: _asInt(rows.first.data['total_reps']),
    );
  }

  Future<double?> _startWeight(int routineId, Exercise exercise) async {
    final row =
        await (_db.select(_db.exerciseStarts)..where(
              (row) =>
                  row.routineId.equals(routineId) &
                  row.exercise.equalsValue(exercise),
            ))
            .getSingleOrNull();
    return row?.startWeightKg;
  }

  LoggedLift _cleanLift(LoggedLift lift) {
    switch (lift.exercise.kind) {
      case ExerciseKind.strength:
        if (lift.weightKg < 0 ||
            lift.weightKg.isNaN ||
            lift.weightKg.isInfinite) {
          throw ArgumentError('Enter a weight for every exercise.');
        }
        for (final reps in lift.reps) {
          if (reps < 0) {
            throw ArgumentError('Enter reps for every set.');
          }
        }
        return LoggedLift(
          exercise: lift.exercise,
          weightKg: roundKg(lift.weightKg),
          reps: List<int>.of(lift.reps),
          setWeights: lift.setWeights,
          targetReps: lift.targetReps,
        );
      case ExerciseKind.jogging:
        final speed = lift.speedKmh;
        final duration = lift.durationSeconds;
        if (speed == null || speed < 0 || speed.isNaN || speed.isInfinite) {
          throw ArgumentError('Enter a speed.');
        }
        if (duration == null || duration <= 0) {
          throw ArgumentError('Enter a duration.');
        }
        return LoggedLift(
          exercise: lift.exercise,
          weightKg: 0,
          reps: const [0],
          targetReps: lift.targetReps,
          speedKmh: roundKg(speed),
          durationSeconds: duration,
        );
      case ExerciseKind.sprinting:
        if (lift.intervals.isEmpty) {
          throw ArgumentError('Enter a duration for every interval.');
        }
        final intervals = <LoggedInterval>[];
        for (final interval in lift.intervals) {
          if (interval.speedKmh < 0 ||
              interval.speedKmh.isNaN ||
              interval.speedKmh.isInfinite) {
            throw ArgumentError('Enter a speed for every interval.');
          }
          if (interval.durationSeconds <= 0) {
            throw ArgumentError('Enter a duration for every interval.');
          }
          intervals.add(
            LoggedInterval(
              speedKmh: roundKg(interval.speedKmh),
              durationSeconds: interval.durationSeconds,
              unit: interval.unit,
            ),
          );
        }
        return LoggedLift(
          exercise: lift.exercise,
          weightKg: 0,
          reps: List<int>.filled(intervals.length, 0),
          targetReps: lift.targetReps,
          intervals: intervals,
        );
    }
  }

  LoggedLift _liftFrom(
    Exercise exercise,
    double weightKg,
    List<SetLog> sets,
    int? targetReps,
  ) {
    switch (exercise.kind) {
      case ExerciseKind.strength:
        return LoggedLift(
          exercise: exercise,
          weightKg: weightKg,
          reps: [for (final set in sets) set.reps],
          setWeights: [for (final set in sets) set.weightKg],
          targetReps: targetReps,
        );
      case ExerciseKind.jogging:
        final set = sets.isEmpty ? null : sets.first;
        return LoggedLift(
          exercise: exercise,
          weightKg: 0,
          reps: const [],
          targetReps: targetReps,
          speedKmh: set?.speedKmh,
          durationSeconds: set?.durationSeconds,
        );
      case ExerciseKind.sprinting:
        return LoggedLift(
          exercise: exercise,
          weightKg: 0,
          reps: const [],
          targetReps: targetReps,
          intervals: [
            for (final set in sets)
              LoggedInterval(
                speedKmh: set.speedKmh ?? 0,
                durationSeconds: set.durationSeconds ?? 0,
                unit: DurationUnit.fromStorage(set.durationUnit),
              ),
          ],
        );
    }
  }

  LogExerciseSeed _seedExercise(
    PrescribedExercise exercise,
    LoggedLift? logged, {
    Exercise? substitute,
  }) {
    final kind = exercise.exercise.kind;
    return LogExerciseSeed(
      exercise: exercise.exercise,
      substitute: substitute,
      sets: exercise.sets,
      targetReps: exercise.reps,
      weightKg: kind == ExerciseKind.strength
          ? (logged?.weightKg ?? exercise.weightKg)
          : null,
      reps: kind == ExerciseKind.strength
          ? _seedReps(logged, exercise.sets, exercise.reps)
          : const [],
      speedKmh: kind == ExerciseKind.jogging
          ? (logged?.speedKmh ?? exercise.targetSpeedKmh)
          : null,
      durationSeconds: kind == ExerciseKind.jogging
          ? (logged?.durationSeconds ?? exercise.targetDurationSeconds)
          : null,
      plan: kind == ExerciseKind.sprinting ? exercise.intervals : const [],
      completed:
          kind == ExerciseKind.sprinting &&
              logged != null &&
              logged.intervals.isNotEmpty
          ? logged.intervals
          : null,
      strengthSets: kind == ExerciseKind.strength
          ? _strengthSets(exercise, logged)
          : const [],
      restSeconds: exercise.restSeconds,
    );
  }

  Future<Map<int, List<LoggedInterval>>> _intervalsByExercise(
    List<int> ids,
  ) async {
    if (ids.isEmpty) {
      return const {};
    }
    final rows =
        await (_db.select(_db.sprintIntervalTargets)
              ..where((row) => row.workoutExerciseId.isIn(ids))
              ..orderBy([(row) => OrderingTerm.asc(row.intervalIndex)]))
            .get();
    final grouped = <int, List<LoggedInterval>>{};
    for (final row in rows) {
      grouped
          .putIfAbsent(row.workoutExerciseId, () => [])
          .add(
            LoggedInterval(
              speedKmh: row.speedKmh,
              durationSeconds: row.durationSeconds,
              unit: DurationUnit.fromStorage(row.durationUnit),
            ),
          );
    }
    return grouped;
  }

  Future<void> _writeIntervals(
    int exerciseId,
    List<LoggedInterval> intervals,
  ) async {
    for (var index = 0; index < intervals.length; index++) {
      final interval = intervals[index];
      await _db
          .into(_db.sprintIntervalTargets)
          .insert(
            SprintIntervalTargetsCompanion.insert(
              workoutExerciseId: exerciseId,
              intervalIndex: index,
              speedKmh: interval.speedKmh,
              durationSeconds: interval.durationSeconds,
              durationUnit: interval.unit.storageKey,
            ),
          );
    }
  }

  List<StrengthSet> _strengthSets(
    PrescribedExercise exercise,
    LoggedLift? logged,
  ) {
    final placeholder = exercise.weightKg ?? 0;
    return [
      for (var index = 0; index < exercise.sets; index++)
        StrengthSet(
          placeholderKg: placeholder,
          placeholderReps: exercise.reps,
          loggedKg: logged != null && index < logged.reps.length
              ? (logged.setWeights != null &&
                        index < logged.setWeights!.length &&
                        logged.setWeights![index] != null
                    ? logged.setWeights![index]
                    : logged.weightKg)
              : null,
          loggedReps: logged != null && index < logged.reps.length
              ? logged.reps[index]
              : null,
        ),
    ];
  }

  List<int> _seedReps(LoggedLift? logged, int sets, int targetReps) {
    if (logged == null) {
      return List<int>.filled(sets, targetReps);
    }
    return [
      for (var index = 0; index < sets; index++)
        index < logged.reps.length ? logged.reps[index] : targetReps,
    ];
  }

  Future<void> _ensureCustom(Exercise exercise) async {
    if (!exercise.custom) {
      return;
    }
    await _db
        .into(_db.customExercises)
        .insert(
          CustomExercisesCompanion.insert(
            storageKey: exercise.storageKey,
            name: exercise.label,
            muscleGroup: exercise.muscleGroup.name,
            equipment: exercise.equipment.name,
            kind: Value(exercise.kind.name),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    Exercise.register(exercise);
  }
}

String _customKey(String name) {
  final slug = name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  final base = 'custom_${slug.isEmpty ? 'exercise' : slug}';
  var key = base;
  var suffix = 2;
  while (Exercise.known(key)) {
    key = '${base}_$suffix';
    suffix++;
  }
  return key;
}

String _requireName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError('Enter a name.');
  }
  return trimmed;
}

void _requireCount(int value, String label) {
  if (value < 1) {
    throw ArgumentError('Enter $label.');
  }
}

({double? weightKg, int? seconds, double? speedKmh}) _targetsFor(
  Exercise exercise, {
  required double? targetWeightKg,
  required int? targetDurationSeconds,
  required double? targetSpeedKmh,
}) {
  switch (exercise.kind) {
    case ExerciseKind.strength:
      return (
        weightKg: _requireWeight(targetWeightKg),
        seconds: null,
        speedKmh: null,
      );
    case ExerciseKind.jogging:
      return (
        weightKg: null,
        seconds: _requireDuration(targetDurationSeconds),
        speedKmh: _requireSpeed(targetSpeedKmh),
      );
    case ExerciseKind.sprinting:
      return (weightKg: null, seconds: null, speedKmh: null);
  }
}

double _requireWeight(double? weightKg) {
  if (weightKg == null ||
      weightKg < 0 ||
      weightKg.isNaN ||
      weightKg.isInfinite) {
    throw ArgumentError('Enter a weight.');
  }
  return roundKg(weightKg);
}

WeightIncrement _requireIncrement(WeightIncrement increment) {
  if (increment.amount < 0 ||
      increment.amount.isNaN ||
      increment.amount.isInfinite) {
    throw ArgumentError('Enter an amount.');
  }
  return WeightIncrement(
    unit: increment.unit,
    amount: roundKg(increment.amount),
  );
}

WeightIncrement? _incrementOverride(double? amount, String? unit) {
  if (amount == null || unit == null) {
    return null;
  }
  return WeightIncrement(unit: IncrementUnit.fromStorage(unit), amount: amount);
}

int _requireDuration(int? seconds) {
  if (seconds == null || seconds < 1) {
    throw ArgumentError('Enter a duration.');
  }
  return seconds;
}

double _requireSpeed(double? speedKmh) {
  if (speedKmh == null ||
      speedKmh < 0 ||
      speedKmh.isNaN ||
      speedKmh.isInfinite) {
    throw ArgumentError('Enter a speed.');
  }
  return roundKg(speedKmh);
}

List<LoggedInterval> _cleanIntervals(List<LoggedInterval> intervals) {
  if (intervals.isEmpty) {
    throw ArgumentError('Add a warm-up interval.');
  }
  final clean = <LoggedInterval>[];
  for (final interval in intervals) {
    if (interval.speedKmh < 0 ||
        interval.speedKmh.isNaN ||
        interval.speedKmh.isInfinite) {
      throw ArgumentError('Enter a speed for every interval.');
    }
    if (interval.durationSeconds <= 0) {
      throw ArgumentError('Enter a duration for every interval.');
    }
    clean.add(
      LoggedInterval(
        speedKmh: roundKg(interval.speedKmh),
        durationSeconds: interval.durationSeconds,
        unit: interval.unit,
      ),
    );
  }
  return clean;
}

List<ProgressPoint> _optionalPoints(
  List<QueryRow> rows,
  List<DateTime> days,
  String column,
) {
  return [
    for (var index = 0; index < rows.length; index++)
      if (rows[index].data[column] != null)
        ProgressPoint(
          day: days[index],
          value: _asDouble(rows[index].data[column]),
        ),
  ];
}

String _formatProgress(double value, String unit) {
  final shown = unit == 'min' ? value.round().toString() : formatKg(value);
  return '$shown $unit';
}

double _asDouble(Object? value) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  throw StateError('Expected a weight, got $value.');
}

int _asInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.round();
  }
  throw StateError('Expected a rep total, got $value.');
}
