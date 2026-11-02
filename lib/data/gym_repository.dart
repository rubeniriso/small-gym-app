import 'package:drift/drift.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/schedule.dart';

class GymRepository {
  GymRepository(this._db);

  final AppDatabase _db;

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
          isTemplate: row.anchorMonday != null,
        ),
    ];
  }

  Future<int?> currentRoutineId() async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((row) => row.id.equals(1))).getSingle();
    return row.currentRoutineId;
  }

  Future<int> createRoutine(String name) {
    final cleanName = _requireName(name);
    return _db.transaction(() async {
      final id = await _db
          .into(_db.routines)
          .insert(RoutinesCompanion.insert(name: cleanName));
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

    return RoutineDetails(
      id: routine.id,
      name: routine.name,
      isCurrent: routine.id == currentId,
      anchorMonday: routine.anchorMonday == null
          ? null
          : parseIsoDate(routine.anchorMonday!),
      days: [
        for (final day in days)
          WeekdayRow(
            weekday: day.weekday,
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

  Future<int> createWorkout({
    required int routineId,
    required String name,
    int? linkWeekday,
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
            targetMinutes: exercise.targetMinutes,
            targetSpeedKmh: exercise.targetSpeedKmh,
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
    int? targetMinutes,
    double? targetSpeedKmh,
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
    final targets = _targetsFor(
      exercise,
      targetWeightKg: targetWeightKg,
      targetMinutes: targetMinutes,
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
            targetMinutes: Value(targets.minutes),
            targetSpeedKmh: Value(targets.speedKmh),
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
    int? targetMinutes,
    double? targetSpeedKmh,
    bool saveWeight = false,
    bool saveJog = false,
  }) async {
    _requireCount(sets, 'sets');
    _requireCount(reps, 'reps');
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
                ? Value(_requireMinutes(targetMinutes))
                : const Value.absent(),
            targetSpeedKmh: saveJog
                ? Value(_requireSpeed(targetSpeedKmh))
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

  Future<List<RoutineExerciseProgress>> routineProgress(int routineId) async {
    final exercises = await _exercisesInRoutine(routineId);
    final rows = <RoutineExerciseProgress>[];
    for (final exercise in exercises) {
      final progress = await exerciseProgress(routineId, exercise);
      final series = progress.series.isEmpty ? null : progress.series.first;
      final latest = series == null || series.points.isEmpty
          ? null
          : series.points.last;
      rows.add(
        RoutineExerciseProgress(
          exercise: exercise,
          sessions: series?.points.length ?? 0,
          latestLabel: latest == null
              ? null
              : _formatProgress(latest.value, series!.unit),
        ),
      );
    }
    return rows;
  }

  Future<ExerciseProgress> exerciseProgress(
    int routineId,
    Exercise exercise,
  ) async {
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
          GROUP BY el.id
          ORDER BY s.logged_on ASC, el.id ASC
          ''',
          variables: [
            Variable.withInt(routineId),
            Variable.withString(exercise.storageKey),
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

  Future<List<Exercise>> _exercisesInRoutine(int routineId) async {
    final rows = await _db
        .customSelect(
          '''
          SELECT we.exercise AS exercise
          FROM workout_exercises we
          INNER JOIN workouts w ON w.id = we.workout_id
          WHERE w.routine_id = ?
          GROUP BY we.exercise
          ORDER BY MIN(w.position), MIN(we.position), we.exercise
          ''',
          variables: [Variable.withInt(routineId)],
        )
        .get();
    return [
      for (final row in rows)
        Exercise.fromStorage(row.read<String>('exercise')),
    ];
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
  }) async {
    final previous = await _previousLog(
      routineId: routineId,
      exercise: exercise,
      beforeIso: formatIsoDate(day),
    );
    final start = await _startWeight(routineId, exercise);
    return prescribe(
      previousWeightKg: previous?.weightKg,
      previousReps: previous?.totalReps,
      startWeightKg: start,
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
      lifts.add(_liftFrom(log.exercise, log.weightKg, sets));
    }
    return lifts;
  }

  Future<List<PlanDay>> planDays(int routineId, DateTime now) async {
    final routine = await routineDetails(routineId);
    final today = dateOnly(now);
    final loggedOn = await _loggedIsoDates(routineId);
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
    final logged = {
      for (final lift in await sessionLifts(home.routineId!, home.day))
        lift.exercise: lift,
    };
    return LogFormData(
      routineId: home.routineId!,
      workoutId: today.workoutId,
      trainingSlotId: today.trainingSlotId,
      day: home.day,
      workoutName: today.workoutName,
      updating: logged.isNotEmpty,
      exercises: [
        for (final exercise in today.exercises)
          _seedExercise(exercise, logged[exercise.exercise]),
      ],
    );
  }

  Future<TodayView> _resolveToday(RoutineDetails routine, DateTime day) async {
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
          routineId: routine.id,
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
        routineId: routine.id,
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
      routineId: routine.id,
      workoutId: weekday.workoutId!,
      day: day,
    );
  }

  Future<TodayWorkout> _workoutToday({
    required int routineId,
    required int workoutId,
    required DateTime day,
    int? trainingSlotId,
  }) async {
    final workout = await workoutDetails(workoutId);
    final logged = await _sessionOn(routineId, formatIsoDate(day));
    final exercises = <PrescribedExercise>[];
    for (final exercise in workout.exercises) {
      exercises.add(
        PrescribedExercise(
          exercise: exercise.exercise,
          sets: exercise.sets,
          reps: exercise.reps,
          weightKg: exercise.exercise.kind == ExerciseKind.strength
              ? await prescribedWeight(
                      routineId: routineId,
                      exercise: exercise.exercise,
                      day: day,
                    ) ??
                    exercise.targetWeightKg
              : null,
          targetMinutes: exercise.targetMinutes,
          targetSpeedKmh: exercise.targetSpeedKmh,
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
          GROUP BY el.id
          ORDER BY s.logged_on DESC, s.id DESC
          LIMIT 1
          ''',
          variables: [
            Variable.withInt(routineId),
            Variable.withString(exercise.storageKey),
            Variable.withString(beforeIso),
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
        );
      case ExerciseKind.jogging:
        final speed = lift.speedKmh;
        final duration = lift.durationSeconds;
        if (speed == null || speed < 0 || speed.isNaN || speed.isInfinite) {
          throw ArgumentError('Enter a speed.');
        }
        if (duration == null || duration <= 0) {
          throw ArgumentError('Enter the minutes.');
        }
        return LoggedLift(
          exercise: lift.exercise,
          weightKg: 0,
          reps: const [0],
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
          intervals: intervals,
        );
    }
  }

  LoggedLift _liftFrom(Exercise exercise, double weightKg, List<SetLog> sets) {
    switch (exercise.kind) {
      case ExerciseKind.strength:
        return LoggedLift(
          exercise: exercise,
          weightKg: weightKg,
          reps: [for (final set in sets) set.reps],
        );
      case ExerciseKind.jogging:
        final set = sets.isEmpty ? null : sets.first;
        return LoggedLift(
          exercise: exercise,
          weightKg: 0,
          reps: const [],
          speedKmh: set?.speedKmh,
          durationSeconds: set?.durationSeconds,
        );
      case ExerciseKind.sprinting:
        return LoggedLift(
          exercise: exercise,
          weightKg: 0,
          reps: const [],
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
    LoggedLift? logged,
  ) {
    final kind = exercise.exercise.kind;
    return LogExerciseSeed(
      exercise: exercise.exercise,
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
          ? (logged?.durationSeconds ??
                (exercise.targetMinutes == null
                    ? null
                    : exercise.targetMinutes! * 60))
          : null,
      plan: kind == ExerciseKind.sprinting ? exercise.intervals : const [],
      completed:
          kind == ExerciseKind.sprinting &&
              logged != null &&
              logged.intervals.isNotEmpty
          ? logged.intervals
          : null,
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

  List<int> _seedReps(LoggedLift? logged, int sets, int targetReps) {
    if (logged == null) {
      return List<int>.filled(sets, targetReps);
    }
    return [
      for (var index = 0; index < sets; index++)
        index < logged.reps.length ? logged.reps[index] : targetReps,
    ];
  }
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

({double? weightKg, int? minutes, double? speedKmh}) _targetsFor(
  Exercise exercise, {
  required double? targetWeightKg,
  required int? targetMinutes,
  required double? targetSpeedKmh,
}) {
  switch (exercise.kind) {
    case ExerciseKind.strength:
      return (
        weightKg: _requireWeight(targetWeightKg),
        minutes: null,
        speedKmh: null,
      );
    case ExerciseKind.jogging:
      return (
        weightKg: null,
        minutes: _requireMinutes(targetMinutes),
        speedKmh: _requireSpeed(targetSpeedKmh),
      );
    case ExerciseKind.sprinting:
      return (weightKg: null, minutes: null, speedKmh: null);
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

int _requireMinutes(int? minutes) {
  if (minutes == null || minutes < 1) {
    throw ArgumentError('Enter the minutes.');
  }
  return minutes;
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
