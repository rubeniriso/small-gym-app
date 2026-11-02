import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/app.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/data/gym_repository.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/schedule.dart';

void main() {
  final anchor = DateTime(2026, 11, 2);

  testWidgets('creating a routine and setting it current shows its name', (
    tester,
  ) async {
    _usePhone(tester);
    await tester.pumpWidget(GymApp(clock: () => DateTime(2026, 11, 2)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Create routine'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empty routine'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Push');
    await tester.tap(find.widgetWithText(TextButton, 'Create'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Push'), findsOneWidget);
    await tester.tap(find.text('Set as current'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Current'), findsWidgets);
    await tester.tap(find.text('Push'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Workouts'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Monday'), findsWidgets);
    expect(find.text('Rest'), findsWidgets);
    await _scrollTo(tester, find.byKey(const Key('day-1')));
    expect(find.text('Workout'), findsWidgets);
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('day-1')),
        matching: find.text('Workout'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('New workout'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Add exercise'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Push'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);
    expect(find.text('Log session'), findsOneWidget);
  });

  testWidgets(
    'home shows today and keeps the prescribed weight after logging',
    (tester) async {
      _usePhone(tester);
      final database = await _seed();
      await _pump(tester, database, anchor);

      expect(find.text('StrongLifts'), findsOneWidget);
      expect(find.text('Workout A'), findsOneWidget);
      expect(find.text('Squat'), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('Barbell Row'), findsOneWidget);
      expect(find.text('Deadlift'), findsNothing);
      expect(find.text('Overhead Press'), findsNothing);
      expect(find.text('5 × 5 · 20 kg'), findsNWidgets(2));
      expect(find.text('5 × 5 · 30 kg'), findsOneWidget);

      await tester.tap(find.text('Log session'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Edit log'), findsOneWidget);
      expect(find.text('5 × 5 · 20 kg'), findsNWidgets(2));
      expect(find.text('5 × 5 · 22.5 kg'), findsNothing);
    },
  );

  testWidgets('home says rest inside the plan and nothing after it', (
    tester,
  ) async {
    _usePhone(tester);
    final database = await _seed();
    await _pump(tester, database, DateTime(2026, 11, 3));
    expect(find.text('StrongLifts'), findsOneWidget);
    expect(find.text('Rest'), findsOneWidget);
    expect(find.text('Workout A'), findsNothing);

    await _pump(tester, database, addCalendarDays(anchor, templateLengthDays));
    expect(find.text('StrongLifts'), findsOneWidget);
    expect(find.text('This plan has no session today.'), findsOneWidget);
  });

  testWidgets('a routine shows every day and today opens the log', (
    tester,
  ) async {
    _usePhone(tester);
    final database = await _seed();
    await _pump(tester, database, anchor);

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('StrongLifts').hitTestable());
    await tester.pumpAndSettle();

    expect(find.text('Plan'), findsOneWidget);
    expect(find.byKey(const Key('day-1')), findsNothing);
    expect(find.text('This week'), findsOneWidget);
    expect(
      find.text('Today is Workout A. Tap a day to see the workout.'),
      findsOneWidget,
    );
    expect(find.text('A'), findsWidgets);
    expect(find.text('B'), findsWidgets);

    expect(
      find.descendant(
        of: find.byKey(const Key('plan-2026-11-03')),
        matching: find.text('Log session'),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('plan-2026-11-02')),
        matching: find.text('Log session'),
      ),
      findsOneWidget,
    );

    await _openPlanDay(tester, '2026-11-04');
    expect(find.widgetWithText(AppBar, 'Day'), findsOneWidget);
    expect(find.text('Workout B').hitTestable(), findsOneWidget);
    expect(find.text('Deadlift').hitTestable(), findsOneWidget);
    expect(find.text('5 × 5 · 40 kg').hitTestable(), findsOneWidget);
    expect(find.text('Log session').hitTestable(), findsNothing);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await _openPlanDay(tester, '2026-11-03');
    expect(find.widgetWithText(AppBar, 'Day'), findsOneWidget);
    expect(find.text('Rest').hitTestable(), findsOneWidget);
    expect(find.text('Log session').hitTestable(), findsNothing);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await _openPlanDay(tester, '2026-11-02');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.widgetWithText(AppBar, 'Day'), findsOneWidget);
    expect(find.text('Workout A').hitTestable(), findsOneWidget);
    expect(find.text('Monday, November 2, 2026').hitTestable(), findsOneWidget);
    expect(find.text('Squat').hitTestable(), findsOneWidget);
    expect(find.text('Bench Press').hitTestable(), findsOneWidget);
    expect(find.text('5 × 5 · 20 kg').hitTestable(), findsNWidgets(2));
    expect(find.text('5 × 5 · 30 kg').hitTestable(), findsOneWidget);
    expect(find.text('Deadlift').hitTestable(), findsNothing);
    await tester.tap(find.text('Log session').hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.widgetWithText(AppBar, 'Log session'), findsOneWidget);
    expect(find.text('Squat').hitTestable(), findsOneWidget);
    expect(find.text('Bench Press').hitTestable(), findsOneWidget);
    await tester.ensureVisible(find.text('Barbell Row').last);
    await tester.pump();
    expect(find.text('Barbell Row').hitTestable(), findsOneWidget);
    expect(find.text('Deadlift').hitTestable(), findsNothing);
    expect(find.text('Save').hitTestable(), findsOneWidget);
  });

  testWidgets('add exercise filters muscle groups and cardio', (tester) async {
    _usePhone(tester);
    await tester.pumpWidget(GymApp(clock: () => DateTime(2026, 11, 2)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Create routine'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empty routine'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Mixed');
    await tester.tap(find.widgetWithText(TextButton, 'Create'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Set as current'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Mixed'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Workouts'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await _scrollTo(tester, find.byKey(const Key('day-1')));
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('day-1')),
        matching: find.text('Workout'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('New workout'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add exercise'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const Key('muscle-all')), findsOneWidget);
    expect(find.text('Bench Press'), findsWidgets);
    expect(find.text('Barbell · Chest'), findsWidgets);

    await tester.tap(find.byKey(const Key('muscle-legs')));
    await tester.pump();
    expect(find.text('Squat'), findsOneWidget);
    expect(find.text('Front Squat'), findsOneWidget);
    expect(find.text('Bench Press'), findsNothing);
    expect(find.text('Jogging'), findsNothing);

    await tester.tap(find.byKey(const Key('muscle-cardio')));
    await tester.pump();
    expect(find.text('Jogging'), findsOneWidget);
    expect(find.text('Sprinting'), findsOneWidget);
    expect(find.text('Squat'), findsNothing);
    await tester.tap(find.byKey(const Key('exercise-jogging')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(_field('Minutes'), '30');
    await tester.enterText(_field('Speed (km/h)'), '9');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Sets'), findsNothing);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add exercise'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const Key('muscle-cardio')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('exercise-sprinting')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Warm-up'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();
    expect(find.text('Enter a duration for every interval.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('sprint-duration-0')), '1');
    await tester.enterText(find.byKey(const Key('sprint-speed-0')), '8');
    await tester.tap(find.text('Add interval'));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('sprint-duration-1')), '1');
    await tester.enterText(find.byKey(const Key('sprint-speed-1')), '14');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Warm-up · 8 km/h · 1 s'), findsOneWidget);
    expect(find.text('Interval 2 · 14 km/h · 1 s'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('30 min · 9 km/h'), findsOneWidget);
    expect(find.text('Warm-up · 8 km/h · 1 s'), findsOneWidget);
    expect(find.text('Interval 2 · 14 km/h · 1 s'), findsOneWidget);

    await tester.tap(find.text('Log session'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Minutes'), findsOneWidget);
    expect(find.text('Speed (km/h)'), findsWidgets);
    expect(find.text('Warm-up · 8 km/h · 1 s'), findsOneWidget);
    expect(find.text('Interval 2 · 14 km/h · 1 s'), findsOneWidget);
    expect(find.text('Weight (kg)'), findsNothing);
    expect(find.text('Sec'), findsNothing);
    expect(find.text('Min'), findsNothing);
    await tester.ensureVisible(find.text('Start'));
    await tester.tap(find.text('Start').hitTestable());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Start').hitTestable());
    await tester.pump();
    expect(find.text('Get ready'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('8 km/h'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Get ready'), findsNothing);
    expect(find.text('Warm-up'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2/2'), findsOneWidget);
    expect(find.text('14 km/h'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Sprint complete.'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Edit log'), findsOneWidget);
  });

  testWidgets('a new lift needs a target weight and the routine charts it', (
    tester,
  ) async {
    _usePhone(tester);
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final repository = GymRepository(database);
    final id = await repository.createRoutine('Push');
    await repository.setCurrentRoutine(id);
    await repository.createWorkout(
      routineId: id,
      name: 'Heavy',
      linkWeekday: DateTime.monday,
    );
    await _pump(tester, database, DateTime(2026, 11, 2));

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Push').hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Edit'));
    await tester.tap(find.text('Edit'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Add exercise'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const Key('exercise-bench_press')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();
    expect(find.text('Enter a weight.'), findsOneWidget);

    await tester.enterText(_field('Weight (kg)'), '60');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(_field('Weight (kg)'), findsOneWidget);
    expect(find.text('60'), findsWidgets);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Progress'), delta: -400);
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    expect(find.text('Bench Press'), findsOneWidget);
    expect(find.text('No sessions yet'), findsOneWidget);
    await tester.tap(find.text('Bench Press'));
    await tester.pumpAndSettle();
    expect(find.text('No sessions logged yet.'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log session'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Push').hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    expect(find.text('60 kg'), findsOneWidget);
    await tester.tap(find.text('Bench Press'));
    await tester.pumpAndSettle();
    expect(find.text('Monday, November 2, 2026 · 60 kg'), findsOneWidget);
  });
}

Future<void> _openPlanDay(WidgetTester tester, String iso) async {
  final scrollable = find.descendant(
    of: find.byKey(const Key('plan-list')),
    matching: find.byType(Scrollable),
  );
  tester.state<ScrollableState>(scrollable).position.jumpTo(0);
  await tester.pump();
  final day = find.byKey(Key('plan-$iso'));
  await tester.scrollUntilVisible(day, 250, scrollable: scrollable);
  await tester.tap(day.hitTestable());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _scrollTo(
  WidgetTester tester,
  Finder finder, {
  double delta = 300,
}) {
  return tester.scrollUntilVisible(
    finder,
    delta,
    scrollable: find.byType(Scrollable).last,
  );
}

Finder _field(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
  );
}

Future<AppDatabase> _seed() async {
  final database = AppDatabase.memory();
  addTearDown(database.close);
  await GymRepository(database).createFromTemplate(
    name: 'StrongLifts',
    anchorMonday: DateTime(2026, 11, 2),
    startWeightsKg: {
      Exercise.squat: 20,
      Exercise.deadlift: 40,
      Exercise.benchPress: 20,
      Exercise.overheadPress: 20,
      Exercise.barbellRow: 30,
    },
  );
  return database;
}

Future<void> _pump(
  WidgetTester tester,
  AppDatabase database,
  DateTime day,
) async {
  await tester.pumpWidget(GymApp(database: database, clock: () => day));
  await tester.pumpAndSettle();
}

void _usePhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
