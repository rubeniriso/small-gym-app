import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/data/gym_repository.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/schedule.dart';
import 'package:gym_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  final anchor = DateTime(2026, 11, 2);

  test('database provider opens sqlite with one settings row', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final database = await container.read(databaseProvider.future);
    final rows = await database.select(database.appSettings).get();
    expect(rows, hasLength(1));
    expect(rows.single.currentRoutineId, isNull);
  });

  test('routines can be created, chosen, and deleted', () async {
    final repository = await _open();
    final first = await repository.createRoutine('  Push  ');
    expect((await repository.listRoutines()).single.name, 'Push');
    expect(await repository.currentRoutineId(), isNull);

    final days = (await repository.routineDetails(first)).days;
    expect(days, hasLength(7));
    expect(days.every((day) => day.isRest && day.workoutId == null), isTrue);

    await repository.setCurrentRoutine(first);
    final second = await repository.createRoutine('Pull');
    expect(await repository.currentRoutineId(), first);

    await repository.setCurrentRoutine(second);
    expect(await repository.currentRoutineId(), second);
    final items = await repository.listRoutines();
    expect(items.singleWhere((item) => item.id == first).isCurrent, isFalse);
    expect(items.singleWhere((item) => item.id == second).isCurrent, isTrue);

    await repository.deleteRoutine(second);
    expect(await repository.currentRoutineId(), isNull);
    expect(await repository.listRoutines(), hasLength(1));
    expect((await repository.loadHome(anchor)).routineName, isNull);
  });

  test('the 12-week template fills the plan and becomes current', () async {
    final repository = await _open();
    final existing = await repository.createRoutine('Old');
    await repository.setCurrentRoutine(existing);

    final id = await repository.createFromTemplate(
      name: 'StrongLifts',
      anchorMonday: anchor,
      startWeightsKg: _weights(),
    );
    expect(await repository.currentRoutineId(), id);

    final details = await repository.routineDetails(id);
    expect(details.anchorMonday, anchor);
    expect(details.startWeightsKg[Exercise.deadlift], 40);
    expect(details.startWeightsKg[Exercise.barbellRow], 30);
    for (final day in details.days) {
      expect(day.isRest, !isTemplateTrainingWeekday(day.weekday));
      expect(day.workoutId, isNull);
    }

    final workoutA = details.workouts.singleWhere(
      (workout) => workout.name == 'Workout A',
    );
    final workoutB = details.workouts.singleWhere(
      (workout) => workout.name == 'Workout B',
    );
    final a = await repository.workoutDetails(workoutA.id);
    final b = await repository.workoutDetails(workoutB.id);
    expect(a.exercises.map((exercise) => exercise.exercise), [
      Exercise.squat,
      Exercise.benchPress,
      Exercise.barbellRow,
    ]);
    expect(b.exercises.map((exercise) => exercise.exercise), [
      Exercise.squat,
      Exercise.overheadPress,
      Exercise.deadlift,
    ]);
    expect(
      b.exercises.every((exercise) => exercise.sets == 5 && exercise.reps == 5),
      isTrue,
    );
    expect(
      b.exercises
          .singleWhere((exercise) => exercise.exercise == Exercise.deadlift)
          .sets,
      5,
    );

    final slots = await repository.trainingSlots(id);
    expect(slots, hasLength(templateSessionCount));
    for (var index = 0; index < slots.length; index++) {
      expect(slots[index].sequenceIndex, index);
      expect(slots[index].workoutId, index.isEven ? workoutA.id : workoutB.id);
    }

    expect(
      () => repository.createFromTemplate(
        name: 'Bad',
        anchorMonday: DateTime(2026, 11, 3),
        startWeightsKg: _weights(),
      ),
      throwsArgumentError,
    );
  });

  test('today follows the template, then says the plan is over', () async {
    final repository = await _open();
    await repository.createFromTemplate(
      name: 'StrongLifts',
      anchorMonday: anchor,
      startWeightsKg: _weights(),
    );

    final monday = await repository.loadHome(anchor);
    final mondayWorkout = monday.today as TodayWorkout;
    expect(monday.routineName, 'StrongLifts');
    expect(mondayWorkout.workoutName, 'Workout A');
    expect(mondayWorkout.exercises.map((exercise) => exercise.exercise), [
      Exercise.squat,
      Exercise.benchPress,
      Exercise.barbellRow,
    ]);
    expect(mondayWorkout.exercises.first.weightKg, 20);
    expect(mondayWorkout.exercises.last.weightKg, 30);

    expect(
      (await repository.loadHome(DateTime(2026, 11, 3))).today,
      isA<TodayRest>(),
    );
    final wednesday =
        (await repository.loadHome(DateTime(2026, 11, 4))).today
            as TodayWorkout;
    expect(wednesday.workoutName, 'Workout B');
    expect(wednesday.exercises.map((exercise) => exercise.weightKg), [
      20,
      20,
      40,
    ]);

    final weekTwo =
        (await repository.loadHome(DateTime(2026, 11, 9))).today
            as TodayWorkout;
    expect(weekTwo.workoutName, 'Workout B');

    expect(
      (await repository.loadHome(DateTime(2026, 11, 1))).today,
      isA<TodayNoSession>(),
    );
    expect(
      (await repository.loadHome(addCalendarDays(anchor, 83))).today,
      isA<TodayRest>(),
    );
    final after = await repository.loadHome(
      addCalendarDays(anchor, templateLengthDays),
    );
    expect(after.routineName, 'StrongLifts');
    expect(after.today, isA<TodayNoSession>());
  });

  test(
    'the next weight reads only the previous session of that lift',
    () async {
      final repository = await _open();
      final id = await repository.createFromTemplate(
        name: 'StrongLifts',
        anchorMonday: anchor,
        startWeightsKg: _weights(),
      );
      final monday = (await repository.loadHome(anchor)).today as TodayWorkout;
      await repository.logSession(
        routineId: id,
        loggedOn: anchor,
        workoutId: monday.workoutId,
        trainingSlotId: monday.trainingSlotId,
        lifts: [
          _lift(Exercise.squat, 20, [5, 5, 5]),
          _lift(Exercise.benchPress, 20, [5, 5, 5, 5, 5]),
          _lift(Exercise.barbellRow, 30, [5, 5, 5, 5, 4]),
        ],
      );

      expect(await _weight(repository, id, Exercise.squat, anchor), 20);
      expect(
        await _weight(repository, id, Exercise.squat, DateTime(2026, 11, 4)),
        20,
      );
      expect(
        await _weight(
          repository,
          id,
          Exercise.benchPress,
          DateTime(2026, 11, 6),
        ),
        22.5,
      );
      expect(
        await _weight(
          repository,
          id,
          Exercise.barbellRow,
          DateTime(2026, 11, 6),
        ),
        30,
      );

      final wednesday =
          (await repository.loadHome(DateTime(2026, 11, 4))).today
              as TodayWorkout;
      await repository.logSession(
        routineId: id,
        loggedOn: DateTime(2026, 11, 4),
        workoutId: wednesday.workoutId,
        trainingSlotId: wednesday.trainingSlotId,
        lifts: [
          _lift(Exercise.squat, 20, [5, 5, 5]),
          _lift(Exercise.overheadPress, 20, [5, 5, 5, 5, 5]),
          _lift(Exercise.deadlift, 40, [5, 5, 5, 5, 5]),
        ],
      );
      expect(
        await _weight(repository, id, Exercise.squat, DateTime(2026, 11, 6)),
        20,
      );
      expect(
        await _weight(repository, id, Exercise.deadlift, DateTime(2026, 11, 9)),
        42.5,
      );

      final friday =
          (await repository.loadHome(DateTime(2026, 11, 6))).today
              as TodayWorkout;
      await repository.logSession(
        routineId: id,
        loggedOn: DateTime(2026, 11, 6),
        workoutId: friday.workoutId,
        trainingSlotId: friday.trainingSlotId,
        lifts: [
          _lift(Exercise.squat, 20, [5, 5, 5, 5, 5]),
          _lift(Exercise.benchPress, 22.5, [5, 5, 5, 5, 5]),
          _lift(Exercise.barbellRow, 30, [5, 5, 5, 5, 5]),
        ],
      );
      expect(
        await _weight(repository, id, Exercise.squat, DateTime(2026, 11, 9)),
        22.5,
      );

      await repository.logSession(
        routineId: id,
        loggedOn: DateTime(2026, 11, 6),
        workoutId: friday.workoutId,
        trainingSlotId: friday.trainingSlotId,
        lifts: [
          _lift(Exercise.squat, 20, [1]),
        ],
      );
      final saved = await repository.sessionLifts(id, DateTime(2026, 11, 6));
      expect(saved, hasLength(1));
      expect(saved.single.reps, [1]);
      expect(
        await _weight(repository, id, Exercise.squat, DateTime(2026, 11, 9)),
        20,
      );
    },
  );

  test('a hand-built week repeats and links a workout', () async {
    final repository = await _open();
    final id = await repository.createRoutine('Garage');
    await repository.setCurrentRoutine(id);
    final workoutId = await repository.createWorkout(
      routineId: id,
      name: 'Full body',
      linkWeekday: DateTime.monday,
    );
    await repository.addExercise(
      workoutId: workoutId,
      exercise: Exercise.squat,
      sets: 3,
      reps: 8,
      targetWeightKg: 50,
    );

    final monday = (await repository.loadHome(anchor)).today as TodayWorkout;
    expect(monday.workoutName, 'Full body');
    expect(monday.exercises.single.sets, 3);
    expect(monday.exercises.single.reps, 8);
    expect(monday.exercises.single.weightKg, 50);
    expect(monday.trainingSlotId, isNull);
    expect(
      (await repository.loadHome(DateTime(2026, 11, 3))).today,
      isA<TodayRest>(),
    );

    final laterMonday = addCalendarDays(anchor, 364);
    expect((await repository.loadHome(laterMonday)).today, isA<TodayWorkout>());

    await repository.logSession(
      routineId: id,
      loggedOn: anchor,
      workoutId: workoutId,
      lifts: [
        _lift(Exercise.squat, 50, [8, 8, 9]),
      ],
    );
    expect(await _weight(repository, id, Exercise.squat, laterMonday), 52.5);
    await repository.logSession(
      routineId: id,
      loggedOn: laterMonday,
      workoutId: workoutId,
      lifts: [
        _lift(Exercise.squat, 52.5, [8, 8, 8]),
      ],
    );
    expect(
      await _weight(
        repository,
        id,
        Exercise.squat,
        addCalendarDays(laterMonday, 7),
      ),
      52.5,
    );

    await repository.setWeekday(
      routineId: id,
      weekday: DateTime.monday,
      isRest: true,
    );
    final day = (await repository.routineDetails(id)).days.first;
    expect(day.isRest, isTrue);
    expect(day.workoutId, isNull);

    await repository.setWeekday(
      routineId: id,
      weekday: DateTime.monday,
      isRest: false,
    );
    expect((await repository.loadHome(anchor)).today, isA<TodayNeedsWorkout>());
  });

  test('plan days list the template and only today can be logged', () async {
    final repository = await _open();
    final id = await repository.createFromTemplate(
      name: 'StrongLifts',
      anchorMonday: anchor,
      startWeightsKg: _weights(),
    );

    final days = await repository.planDays(id, anchor);
    expect(days, hasLength(templateLengthDays));
    expect(days.where((day) => day.isToday), hasLength(1));

    final monday = days.first;
    expect(formatIsoDate(monday.date), '2026-11-02');
    expect(monday.workoutName, 'Workout A');
    expect(monday.shortLabel, 'A');
    expect(monday.canLog, isTrue);
    expect(monday.logged, isFalse);

    expect(days[1].isRest, isTrue);
    expect(days[1].canLog, isFalse);
    expect(days[1].shortLabel, '–');

    expect(days[2].workoutName, 'Workout B');
    expect(days[2].shortLabel, 'B');
    expect(days[2].canLog, isFalse);

    expect(days[7].workoutName, 'Workout B');
    expect(days[7].isToday, isFalse);
    expect(days[7].canLog, isFalse);

    final today = (await repository.loadHome(anchor)).today as TodayWorkout;
    await repository.logSession(
      routineId: id,
      loggedOn: anchor,
      workoutId: today.workoutId,
      trainingSlotId: today.trainingSlotId,
      lifts: [
        _lift(Exercise.squat, 20, [5, 5, 5, 5, 5]),
      ],
    );
    final after = await repository.planDays(id, anchor);
    expect(after.first.logged, isTrue);
    expect(after.first.canLog, isTrue);
    expect(after[1].logged, isFalse);

    final outside = await repository.planDays(
      id,
      addCalendarDays(anchor, templateLengthDays),
    );
    expect(outside.any((day) => day.isToday), isFalse);
    expect(outside.any((day) => day.canLog), isFalse);
  });

  test('a hand-built week only lets today be logged', () async {
    final repository = await _open();
    final id = await repository.createRoutine('Garage');
    await repository.createWorkout(
      routineId: id,
      name: 'Full body',
      linkWeekday: DateTime.monday,
    );

    final days = await repository.planDays(id, anchor);
    expect(days, hasLength(7));
    expect(days.first.workoutName, 'Full body');
    expect(days.first.shortLabel, 'F');
    expect(days.first.canLog, isTrue);
    expect(days.where((day) => day.canLog), hasLength(1));
    expect(days[1].isRest, isTrue);

    final tuesday = await repository.planDays(id, DateTime(2026, 11, 3));
    expect(tuesday.where((day) => day.canLog), isEmpty);
    expect(tuesday.first.workoutName, 'Full body');
    expect(tuesday[1].isToday, isTrue);
    expect(tuesday[1].isRest, isTrue);
  });

  test('jogging and sprinting keep their own pace log', () async {
    final repository = await _open();
    final id = await repository.createRoutine('Mixed');
    await repository.setCurrentRoutine(id);
    final workoutId = await repository.createWorkout(
      routineId: id,
      name: 'Mixed',
      linkWeekday: DateTime.monday,
    );
    await repository.addExercise(
      workoutId: workoutId,
      exercise: Exercise.squat,
      targetWeightKg: 20,
    );
    await repository.addExercise(
      workoutId: workoutId,
      exercise: Exercise.jogging,
      sets: 1,
      reps: 1,
      targetMinutes: 30,
      targetSpeedKmh: 9.5,
    );
    await expectLater(
      repository.addExercise(
        workoutId: workoutId,
        exercise: Exercise.sprinting,
      ),
      throwsA(
        isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          'Add a warm-up interval.',
        ),
      ),
    );
    await repository.addExercise(
      workoutId: workoutId,
      exercise: Exercise.sprinting,
      intervals: const [
        LoggedInterval(
          speedKmh: 8,
          durationSeconds: 3 * 60,
          unit: DurationUnit.minutes,
        ),
        LoggedInterval(
          speedKmh: 14,
          durationSeconds: 45,
          unit: DurationUnit.seconds,
        ),
      ],
    );
    final sprintRow = (await repository.workoutDetails(workoutId)).exercises
        .singleWhere((exercise) => exercise.exercise == Exercise.sprinting);
    expect(sprintRow.sets, 2);
    expect(sprintRow.intervals.first.unit, DurationUnit.minutes);

    await repository.logSession(
      routineId: id,
      loggedOn: anchor,
      workoutId: workoutId,
      lifts: [
        _lift(Exercise.squat, 20, [5, 5, 5, 5, 5]),
        LoggedLift(
          exercise: Exercise.jogging,
          weightKg: 0,
          reps: const [],
          speedKmh: 9.5,
          durationSeconds: 30 * 60,
        ),
        LoggedLift(
          exercise: Exercise.sprinting,
          weightKg: 0,
          reps: const [],
          intervals: const [
            LoggedInterval(
              speedKmh: 8,
              durationSeconds: 3 * 60,
              unit: DurationUnit.minutes,
            ),
            LoggedInterval(
              speedKmh: 14,
              durationSeconds: 45,
              unit: DurationUnit.seconds,
            ),
          ],
        ),
      ],
    );

    final saved = await repository.sessionLifts(id, anchor);
    final jogging = saved.singleWhere(
      (lift) => lift.exercise == Exercise.jogging,
    );
    expect(jogging.speedKmh, 9.5);
    expect(jogging.durationSeconds, 1800);
    final sprint = saved.singleWhere(
      (lift) => lift.exercise == Exercise.sprinting,
    );
    expect(sprint.intervals, hasLength(2));
    expect(sprint.intervals[0].speedKmh, 8);
    expect(sprint.intervals[0].durationSeconds, 180);
    expect(sprint.intervals[0].unit, DurationUnit.minutes);
    expect(sprint.intervals[1].speedKmh, 14);
    expect(sprint.intervals[1].durationSeconds, 45);
    expect(sprint.intervals[1].unit, DurationUnit.seconds);

    final form = await repository.loadLogForm(anchor);
    final seeded = form!.exercises.singleWhere(
      (exercise) => exercise.exercise == Exercise.sprinting,
    );
    expect(seeded.plan[0].unit, DurationUnit.minutes);
    expect(seeded.plan[0].durationSeconds, 180);
    expect(seeded.completed, isNotNull);
    expect(seeded.completed![1].durationSeconds, 45);

    expect(
      await _weight(repository, id, Exercise.squat, DateTime(2026, 11, 9)),
      22.5,
    );
    final home = await repository.loadHome(anchor);
    final today = home.today as TodayWorkout;
    expect(
      today.exercises
          .singleWhere((exercise) => exercise.exercise == Exercise.jogging)
          .weightKg,
      isNull,
    );
    final prescribed = today.exercises.singleWhere(
      (exercise) => exercise.exercise == Exercise.sprinting,
    );
    expect(prescribed.sets, 2);
    expect(prescribed.intervals, hasLength(2));
    expect(
      await repository.loadDay(id, DateTime(2026, 11, 3)),
      isA<TodayRest>(),
    );
    final monday = await repository.loadDay(id, anchor);
    expect(
      (monday as TodayWorkout).exercises
          .singleWhere((exercise) => exercise.exercise == Exercise.sprinting)
          .intervals,
      hasLength(2),
    );
    await repository.deleteRoutine(id);
  });

  test('progress charts stay inside one routine', () async {
    final repository = await _open();
    final first = await repository.createRoutine('Push');
    final second = await repository.createRoutine('Other');
    final firstWorkout = await repository.createWorkout(
      routineId: first,
      name: 'Push',
      linkWeekday: DateTime.monday,
    );
    final secondWorkout = await repository.createWorkout(
      routineId: second,
      name: 'Other',
      linkWeekday: DateTime.monday,
    );
    await repository.addExercise(
      workoutId: firstWorkout,
      exercise: Exercise.benchPress,
      targetWeightKg: 60,
    );
    await repository.addExercise(
      workoutId: secondWorkout,
      exercise: Exercise.benchPress,
      targetWeightKg: 40,
    );
    await repository.logSession(
      routineId: first,
      loggedOn: anchor,
      workoutId: firstWorkout,
      lifts: [
        _lift(Exercise.benchPress, 60, [5, 5, 5, 5, 5]),
      ],
    );
    await repository.logSession(
      routineId: first,
      loggedOn: DateTime(2026, 11, 6),
      workoutId: firstWorkout,
      lifts: [
        _lift(Exercise.benchPress, 62.5, [5, 5, 5, 5, 5]),
      ],
    );
    await repository.logSession(
      routineId: second,
      loggedOn: anchor,
      workoutId: secondWorkout,
      lifts: [
        _lift(Exercise.benchPress, 40, [5, 5, 5, 5, 3]),
      ],
    );

    final listed = await repository.routineProgress(first);
    expect(listed.map((row) => row.exercise), [Exercise.benchPress]);
    expect(listed.single.latestLabel, '62.5 kg');

    final progress = await repository.exerciseProgress(
      first,
      Exercise.benchPress,
    );
    expect(progress.series.single.label, 'Weight');
    expect(progress.series.single.points.map((point) => point.value), [
      60,
      62.5,
    ]);
    final other = await repository.exerciseProgress(
      second,
      Exercise.benchPress,
    );
    expect(other.series.single.points.single.value, 40);
  });
}

Future<GymRepository> _open() async {
  final database = AppDatabase.memory();
  addTearDown(database.close);
  return GymRepository(database);
}

Map<Exercise, double> _weights() {
  return {
    Exercise.squat: 20,
    Exercise.deadlift: 40,
    Exercise.benchPress: 20,
    Exercise.overheadPress: 20,
    Exercise.barbellRow: 30,
  };
}

LoggedLift _lift(Exercise exercise, double weightKg, List<int> reps) {
  return LoggedLift(exercise: exercise, weightKg: weightKg, reps: reps);
}

Future<double?> _weight(
  GymRepository repository,
  int routineId,
  Exercise exercise,
  DateTime day,
) {
  return repository.prescribedWeight(
    routineId: routineId,
    exercise: exercise,
    day: day,
  );
}
