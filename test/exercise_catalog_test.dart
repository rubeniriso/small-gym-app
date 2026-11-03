import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/app.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/data/gym_repository.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/routine_kind.dart';

void main() {
  test('each built-in exercise has the equipment it uses', () {
    expect(Equipment.values.map((item) => item.label).toList(), [
      'Barbell',
      'Cable',
      'Dumbbell',
      'Bodyweight',
    ]);

    const barbell = {
      'Bench Press',
      'Incline Bench Press',
      'Close-Grip Bench Press',
      'Deadlift',
      'Romanian Deadlift',
      'Barbell Row',
      'Pendlay Row',
      'Overhead Press',
      'Barbell Curl',
      'Skull Crusher',
      'Squat',
      'Front Squat',
      'Hip Thrust',
      'Barbell Lunge',
      'Good Morning',
    };
    const dumbbell = {
      'Dumbbell Bench Press',
      'Incline Dumbbell Press',
      'Dumbbell Fly',
      'Dumbbell Row',
      'Dumbbell Shrug',
      'Dumbbell Shoulder Press',
      'Lateral Raise',
      'Rear Delt Fly',
      'Arnold Press',
      'Dumbbell Curl',
      'Hammer Curl',
      'Overhead Triceps Extension',
      'Goblet Squat',
      'Dumbbell Lunge',
      'Bulgarian Split Squat',
      'Dumbbell Romanian Deadlift',
      'Dumbbell Calf Raise',
      'Dumbbell Russian Twist',
      'Weighted Crunch',
      'Dumbbell Side Bend',
    };
    const cable = {
      'Cable Fly',
      'Cable Crossover',
      'Lat Pulldown',
      'Seated Cable Row',
      'Straight-Arm Pulldown',
      'Face Pull',
      'Cable Lateral Raise',
      'Cable Curl',
      'Triceps Pushdown',
      'Overhead Cable Extension',
      'Cable Pull-Through',
      'Cable Kickback',
      'Cable Crunch',
      'Cable Woodchop',
    };
    const bodyweight = {'Jogging', 'Sprinting'};

    expect(Exercise.builtIn.map((exercise) => exercise.label).toSet(), {
      ...barbell,
      ...dumbbell,
      ...cable,
      ...bodyweight,
    });
    for (final exercise in Exercise.builtIn) {
      final expected = barbell.contains(exercise.label)
          ? Equipment.barbell
          : dumbbell.contains(exercise.label)
          ? Equipment.dumbbell
          : cable.contains(exercise.label)
          ? Equipment.cable
          : Equipment.none;
      expect(exercise.equipment, expected, reason: exercise.label);
    }
    expect(Exercise.jogging.detail, 'Bodyweight · Cardio');
    expect(Exercise.squat.detail, 'Barbell · Legs');
    expect(Exercise.dumbbellCurl.detail, 'Dumbbell · Biceps');
    expect(Exercise.latPulldown.detail, 'Cable · Back');
    expect(Exercise.cableCurl.detail, 'Cable · Biceps');
  });

  test('custom exercises persist and arms are split', () async {
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final repository = GymRepository(database);
    await repository.loadCatalog();

    expect(Exercise.barbellCurl.muscleGroup, MuscleGroup.biceps);
    expect(Exercise.dumbbellCurl.muscleGroup, MuscleGroup.biceps);
    expect(Exercise.hammerCurl.muscleGroup, MuscleGroup.biceps);
    expect(Exercise.skullCrusher.muscleGroup, MuscleGroup.triceps);
    expect(Exercise.overheadTricepsExtension.muscleGroup, MuscleGroup.triceps);
    expect(
      MuscleGroup.values.map((group) => group.name),
      isNot(contains('arms')),
    );

    final created = await repository.createExercise(
      name: '  Bayesian   Curl ',
      muscleGroup: MuscleGroup.biceps,
      equipment: Equipment.dumbbell,
      kind: ExerciseKind.strength,
    );
    expect(created.label, 'Bayesian Curl');
    expect(created.custom, isTrue);
    expect(created.storageKey, 'custom_bayesian_curl');
    expect(
      repository.createExercise(
        name: 'bayesian curl',
        muscleGroup: MuscleGroup.biceps,
        equipment: Equipment.barbell,
        kind: ExerciseKind.strength,
      ),
      throwsArgumentError,
    );

    final routine = await repository.createRoutine('Arms day');
    final workout = await repository.createWorkout(
      routineId: routine,
      name: 'Day 1',
    );
    await repository.addExercise(
      workoutId: workout,
      exercise: created,
      sets: 3,
      reps: 10,
      targetWeightKg: 12,
    );

    final copy = await repository.importRoutine(
      await repository.exportRoutine(routine),
    );
    final copied = await repository.workoutDetails(
      (await repository.routineDetails(copy)).workouts.single.id,
    );
    final exercise = copied.exercises.single;
    expect(exercise.exercise.label, 'Bayesian Curl');
    expect(exercise.exercise.muscleGroup, MuscleGroup.biceps);
    expect(exercise.targetWeightKg, 12);

    final reloaded = GymRepository(database);
    await reloaded.loadCatalog();
    expect(
      Exercise.catalog.map((item) => item.label),
      contains('Bayesian Curl'),
    );

    final pulldown = await repository.createExercise(
      name: 'Single-Arm Pulldown',
      muscleGroup: MuscleGroup.back,
      equipment: Equipment.cable,
      kind: ExerciseKind.strength,
    );
    expect(pulldown.equipment, Equipment.cable);
    expect(pulldown.detail, 'Cable · Back');

    final pushUp = await repository.createExercise(
      name: 'Push-up',
      muscleGroup: MuscleGroup.chest,
      equipment: Equipment.none,
      kind: ExerciseKind.strength,
    );
    expect(pushUp.equipment, Equipment.none);
    expect(pushUp.detail, 'Bodyweight · Chest');

    final vestJog = await repository.createExercise(
      name: 'Vest Jog',
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.dumbbell,
      kind: ExerciseKind.jogging,
    );
    expect(vestJog.muscleGroup, MuscleGroup.cardio);
    expect(vestJog.equipment, Equipment.dumbbell);
  });

  testWidgets('exercises can be created from the menu and a workout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase.memory();
    addTearDown(database.close);
    final repository = GymRepository(database);
    await repository.loadCatalog();
    final routine = await repository.createRoutine(
      'Push',
      kind: RoutineKind.dynamicDay,
    );
    await repository.createWorkout(routineId: routine, name: 'Day 1');

    await tester.pumpWidget(GymApp(database: database));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Exercises'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('muscle-arms')), findsNothing);
    expect(find.text('Arms'), findsNothing);
    expect(find.text('Equipment'), findsOneWidget);
    expect(find.byKey(const Key('equipment-barbell')), findsOneWidget);
    expect(find.byKey(const Key('equipment-cable')), findsOneWidget);
    expect(find.byKey(const Key('equipment-dumbbell')), findsOneWidget);
    expect(find.byKey(const Key('equipment-none')), findsOneWidget);

    await tester.tap(find.byKey(const Key('equipment-none')));
    await tester.pump();
    expect(find.text('Jogging'), findsOneWidget);
    expect(find.text('Sprinting'), findsOneWidget);
    expect(find.text('Squat'), findsNothing);
    expect(find.text('Bodyweight · Cardio'), findsWidgets);

    await tester.tap(find.byKey(const Key('equipment-cable')));
    await tester.pump();
    expect(find.text('Lat Pulldown'), findsOneWidget);
    expect(find.text('Jogging'), findsNothing);
    expect(find.text('No exercises match.'), findsNothing);

    await tester.tap(find.byKey(const Key('equipment-barbell')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('muscle-legs')));
    await tester.pump();
    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('Front Squat'), findsOneWidget);
    expect(find.text('Goblet Squat'), findsNothing);
    expect(find.text('Jogging'), findsNothing);

    await tester.tap(find.byKey(const Key('muscle-all')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('equipment-all')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('muscle-biceps')));
    await tester.pump();
    expect(find.text('Barbell Curl'), findsOneWidget);
    expect(find.text('Skull Crusher'), findsNothing);
    await tester.tap(find.byKey(const Key('muscle-triceps')));
    await tester.pump();
    expect(find.text('Skull Crusher'), findsOneWidget);
    expect(find.text('Barbell Curl'), findsNothing);

    await tester.tap(find.byKey(const Key('muscle-biceps')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('catalog-create-exercise')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('new-equipment-cable')), findsOneWidget);
    expect(find.byKey(const Key('new-equipment-none')), findsOneWidget);
    await tester.tap(find.byKey(const Key('new-muscle-cardio')));
    await tester.pump();
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('new-equipment-none')))
          .selected,
      isTrue,
    );
    expect(find.byKey(const Key('new-kind-jogging')), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('catalog-create-exercise')));
    await tester.pumpAndSettle();
    await _nameExercise(
      tester,
      'Concentration Curl',
      'biceps',
      equipment: 'dumbbell',
    );
    await tester.scrollUntilVisible(
      find.text('Concentration Curl'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Concentration Curl'), findsOneWidget);
    expect(
      tester
          .widget<ListTile>(
            find.byKey(const Key('exercise-custom_concentration_curl')),
          )
          .subtitle,
      isA<Text>().having((text) => text.data, 'text', 'Dumbbell · Biceps'),
    );

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Push'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Day 1'));
    await tester.pumpAndSettle();

    final add = tester.getCenter(
      find.widgetWithText(OutlinedButton, 'Add exercise'),
    );
    final plus = tester.getCenter(
      find.byKey(const Key('workout-create-exercise')),
    );
    expect(plus.dx, greaterThan(add.dx));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add exercise'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('equipment-cable')), findsOneWidget);
    await tester.tap(find.byKey(const Key('muscle-biceps')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('equipment-dumbbell')));
    await tester.pump();
    expect(find.text('Dumbbell Curl'), findsOneWidget);
    expect(find.text('Concentration Curl'), findsOneWidget);
    expect(find.text('Cable Curl'), findsNothing);
    expect(find.text('Barbell Curl'), findsNothing);
    await tester.tap(find.byKey(const Key('equipment-all')));
    await tester.pump();
    expect(find.text('Barbell Curl'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Concentration Curl'),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Concentration Curl'), findsOneWidget);
    expect(find.text('Cable Curl'), findsOneWidget);
    await tester.tap(find.byKey(const Key('picker-create-exercise')));
    await tester.pumpAndSettle();
    await _nameExercise(tester, 'Incline Curl', 'biceps');
    await tester.enterText(find.byType(TextField).last, '10');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();
    expect(find.text('Incline Curl'), findsOneWidget);

    await tester.tap(find.byKey(const Key('workout-create-exercise')));
    await tester.pumpAndSettle();
    await _nameExercise(tester, 'Upright Row', 'shoulders');
    await tester.enterText(find.byType(TextField).last, '8');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();
    expect(find.text('Upright Row'), findsOneWidget);
    expect(find.text('Incline Curl'), findsOneWidget);
  });
}

Future<void> _nameExercise(
  WidgetTester tester,
  String name,
  String muscle, {
  String? equipment,
}) async {
  await tester.enterText(find.byKey(const Key('exercise-name')), name);
  await tester.tap(find.byKey(Key('new-muscle-$muscle')));
  await tester.pump();
  if (equipment != null) {
    final chip = find.byKey(Key('new-equipment-$equipment'));
    await tester.ensureVisible(chip);
    await tester.pump();
    await tester.tap(chip);
    await tester.pump();
  }
  await tester.tap(find.byKey(const Key('exercise-save')));
  await tester.pumpAndSettle();
}
