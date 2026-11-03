import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/app.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/data/gym_repository.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/routine_kind.dart';
import 'package:gym_app/domain/schedule.dart';

void main() {
  final monday = DateTime(2026, 11, 2);

  test('a custom pattern repeats forward and backward from its start', () {
    expect(monday.weekday, DateTime.monday);
    const length = 5;
    expect(patternIndex(start: monday, day: monday, length: length), 0);
    expect(
      patternIndex(start: monday, day: DateTime(2026, 11, 3), length: length),
      1,
    );
    expect(
      patternIndex(start: monday, day: DateTime(2026, 11, 4), length: length),
      2,
    );
    expect(
      patternIndex(start: monday, day: DateTime(2026, 11, 5), length: length),
      3,
    );
    expect(
      patternIndex(start: monday, day: DateTime(2026, 11, 6), length: length),
      4,
    );
    expect(
      patternIndex(start: monday, day: DateTime(2026, 11, 7), length: length),
      0,
    );
    expect(
      patternIndex(start: monday, day: DateTime(2026, 11, 8), length: length),
      1,
    );
    expect(
      patternIndex(start: monday, day: DateTime(2026, 11, 9), length: length),
      2,
    );
    expect(
      patternIndex(start: monday, day: DateTime(2026, 11, 1), length: length),
      4,
    );
  });

  test('a custom pattern maps each date to a workout or rest', () async {
    final repository = await _open();
    final id = await repository.createRoutine(
      'PPL',
      kind: RoutineKind.customPattern,
      patternStart: monday,
    );
    final push = await repository.createWorkout(routineId: id, name: 'Push');
    final pull = await repository.createWorkout(routineId: id, name: 'Pull');
    final legs = await repository.createWorkout(routineId: id, name: 'Legs');
    for (var count = 0; count < 5; count++) {
      await repository.addPatternDay(id);
    }
    await repository.setPatternDay(
      routineId: id,
      position: 1,
      isRest: false,
      workoutId: push,
    );
    await repository.setPatternDay(
      routineId: id,
      position: 2,
      isRest: false,
      workoutId: pull,
    );
    await repository.setPatternDay(
      routineId: id,
      position: 3,
      isRest: false,
      workoutId: legs,
    );

    final details = await repository.routineDetails(id);
    expect(details.kind, RoutineKind.customPattern);
    expect(details.isTemplate, isFalse);
    expect(details.patternStart, monday);
    expect(details.days, isEmpty);
    expect(details.pattern.map((day) => day.position), [1, 2, 3, 4, 5]);
    expect(
      details.pattern.map((day) => day.isRest ? 'Rest' : day.workoutName),
      ['Push', 'Pull', 'Legs', 'Rest', 'Rest'],
    );
    final listed = await repository.listRoutines();
    expect(listed.single.isTemplate, isFalse);
    expect(listed.single.kind, RoutineKind.customPattern);

    expect(
      (await repository.loadDay(id, monday) as TodayWorkout).workoutName,
      'Push',
    );
    expect(
      (await repository.loadDay(
        id,
        DateTime(2026, 11, 3),
      ) as TodayWorkout).workoutName,
      'Pull',
    );
    expect(
      (await repository.loadDay(
        id,
        DateTime(2026, 11, 4),
      ) as TodayWorkout).workoutName,
      'Legs',
    );
    expect(
      await repository.loadDay(id, DateTime(2026, 11, 5)),
      isA<TodayRest>(),
    );
    expect(
      await repository.loadDay(id, DateTime(2026, 11, 6)),
      isA<TodayRest>(),
    );
    expect(
      (await repository.loadDay(
        id,
        DateTime(2026, 11, 7),
      ) as TodayWorkout).workoutName,
      'Push',
    );
    expect(
      (await repository.loadDay(
        id,
        DateTime(2026, 11, 8),
      ) as TodayWorkout).workoutName,
      'Pull',
    );
    expect(
      (await repository.loadDay(
        id,
        DateTime(2026, 11, 9),
      ) as TodayWorkout).workoutName,
      'Legs',
    );
    expect(
      await repository.loadDay(id, DateTime(2026, 11, 1)),
      isA<TodayRest>(),
    );

    final plan = await repository.planDays(id, monday);
    expect(plan, hasLength(templateLengthDays));
    expect(plan.first.date, monday);
    expect(_named(plan, DateTime(2026, 11, 7)), 'Push');
    expect(_named(plan, DateTime(2026, 11, 5)), 'Rest');
    expect(_named(plan, DateTime(2026, 11, 8)), 'Pull');

    final calendar = await repository.activityDays(id, monday);
    final saturday = calendar.singleWhere(
      (day) => day.date == DateTime(2026, 11, 7),
    );
    expect(saturday.planName, 'Push');
    expect(saturday.logged, isFalse);
    final thursday = calendar.singleWhere(
      (day) => day.date == DateTime(2026, 11, 5),
    );
    expect(thursday.planRest, isTrue);

    await repository.setPatternStart(
      routineId: id,
      start: DateTime(2026, 11, 4),
    );
    expect(
      (await repository.loadDay(
        id,
        DateTime(2026, 11, 4),
      ) as TodayWorkout).workoutName,
      'Push',
    );
    expect(await repository.loadDay(id, monday), isA<TodayRest>());

    await repository.setPatternStart(routineId: id, start: monday);
    await repository.removePatternDay(routineId: id, position: 4);
    final shortened = await repository.routineDetails(id);
    expect(
      shortened.pattern.map((day) => day.isRest ? 'Rest' : day.workoutName),
      ['Push', 'Pull', 'Legs', 'Rest'],
    );
    expect(
      (await repository.loadDay(
        id,
        DateTime(2026, 11, 6),
      ) as TodayWorkout).workoutName,
      'Push',
    );

    final copy = await repository.importRoutine(
      await repository.exportRoutine(id),
    );
    final imported = await repository.routineDetails(copy);
    expect(imported.kind, RoutineKind.customPattern);
    expect(imported.patternStart, monday);
    expect(
      (await repository.loadDay(
        copy,
        DateTime(2026, 11, 6),
      ) as TodayWorkout).workoutName,
      'Push',
    );
    expect(
      (await repository.loadDay(
        copy,
        DateTime(2026, 11, 7),
      ) as TodayWorkout).workoutName,
      'Pull',
    );

    final week = await repository.createRoutine('Week');
    final staticDetails = await repository.routineDetails(week);
    expect(staticDetails.kind, RoutineKind.staticWeek);
    expect(staticDetails.pattern, isEmpty);
    expect(staticDetails.days, hasLength(7));
    expect(staticDetails.patternStart, isNull);
    expect(
      await repository.loadDay(week, DateTime(2026, 11, 3)),
      isA<TodayRest>(),
    );
  });

  testWidgets('creating a routine offers Custom Pattern', (tester) async {
    _usePhone(tester);
    await tester.pumpWidget(GymApp(clock: () => monday));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Create routine'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empty routine'));
    await tester.pump();

    expect(find.text('Custom Pattern'), findsOneWidget);
    await tester.tap(find.text('Custom Pattern'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Split');
    await tester.tap(find.widgetWithText(TextButton, 'Create'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Split'), findsOneWidget);
    expect(find.text('Custom Pattern'), findsOneWidget);
    await tester.tap(find.text('Split'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Plan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Add day'), findsOneWidget);
    expect(find.text('Starts Monday, November 2, 2026'), findsOneWidget);
    await tester.tap(find.text('Add day'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const Key('pattern-day-1')), findsOneWidget);
    expect(find.text('1  Rest'), findsOneWidget);
  });

  testWidgets('the routine screen shows the pattern on the calendar', (
    tester,
  ) async {
    _usePhone(tester);
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final repository = GymRepository(database);
    final id = await repository.createRoutine(
      'PPL',
      kind: RoutineKind.customPattern,
      patternStart: monday,
    );
    await repository.setCurrentRoutine(id);
    final push = await repository.createWorkout(routineId: id, name: 'Push');
    final pull = await repository.createWorkout(routineId: id, name: 'Pull');
    final legs = await repository.createWorkout(routineId: id, name: 'Legs');
    for (var count = 0; count < 5; count++) {
      await repository.addPatternDay(id);
    }
    await repository.setPatternDay(
      routineId: id,
      position: 1,
      isRest: false,
      workoutId: push,
    );
    await repository.setPatternDay(
      routineId: id,
      position: 2,
      isRest: false,
      workoutId: pull,
    );
    await repository.setPatternDay(
      routineId: id,
      position: 3,
      isRest: false,
      workoutId: legs,
    );

    await tester.pumpWidget(GymApp(database: database, clock: () => monday));
    await tester.pumpAndSettle();
    expect(find.text('Push'), findsOneWidget);

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PPL'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Plan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('1  Push'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('5  Rest'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('4  Rest'), findsOneWidget);
    expect(find.text('5  Rest'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('plan-2026-11-05')),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('plan-2026-11-02')),
        matching: find.text('Push'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('plan-2026-11-05')),
        matching: find.text('Rest'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('plan-2026-11-07')),
        matching: find.text('Push'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Progress'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Calendar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('· Push'), findsOneWidget);
    await tester.tap(find.text('–').first);
    await tester.pump();
    expect(find.textContaining('· Rest'), findsOneWidget);
  });

  testWidgets('Change type offers the three kinds and keeps workouts', (
    tester,
  ) async {
    _usePhone(tester);
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final repository = GymRepository(database);
    await repository.createRoutine('Push');
    final routines = await repository.listRoutines();
    await repository.createWorkout(
      routineId: routines.single.id,
      name: 'Bench',
    );

    await tester.pumpWidget(GymApp(database: database));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Push'));
    await tester.pumpAndSettle();

    expect(find.text('Make dynamic'), findsNothing);
    expect(find.text('Change type'), findsOneWidget);
    await tester.tap(find.byKey(const Key('change-type')));
    await tester.pumpAndSettle();
    expect(find.text('Static'), findsOneWidget);
    expect(find.text('Dynamic'), findsOneWidget);
    expect(find.text('Custom Pattern'), findsOneWidget);
    await tester.tap(find.byKey(const Key('routine-type-customPattern')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('change-type-save')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();
    expect(find.text('Bench'), findsOneWidget);
    expect(find.text('Change type'), findsOneWidget);
  });
}

String _named(List<PlanDay> days, DateTime date) {
  final day = days.singleWhere((item) => item.date == date);
  if (day.isRest) {
    return 'Rest';
  }
  return day.workoutName ?? '';
}

Future<GymRepository> _open() async {
  final database = AppDatabase.memory();
  addTearDown(database.close);
  return GymRepository(database);
}

void _usePhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
