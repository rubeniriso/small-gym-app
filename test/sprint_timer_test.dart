import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/sprint.dart';
import 'package:gym_app/screens/sprint_timer_screen.dart';

void main() {
  const intervals = [
    LoggedInterval(speedKmh: 8, durationSeconds: 2, unit: DurationUnit.seconds),
    LoggedInterval(
      speedKmh: 14,
      durationSeconds: 1,
      unit: DurationUnit.seconds,
    ),
  ];

  test('the ring starts empty at 12 o’clock and fills clockwise', () {
    expect(sprintRingStartAngle, -3.141592653589793 / 2);
    expect(sprintRingSweep(0), 0);
    expect(sprintRingSweep(0.5), closeTo(3.141592653589793, 0.0001));
    expect(sprintRingSweep(1), closeTo(3.141592653589793 * 2, 0.0001));
  });

  test('grace ends on one pump and each interval follows the elapsed time', () {
    const grace = Duration(seconds: 5);
    final ready = sprintPhase(
      started: true,
      elapsed: const Duration(milliseconds: 2500),
      grace: grace,
      intervals: intervals,
    );
    expect(ready.kind, SprintPhaseKind.grace);
    expect(ready.progress, closeTo(0.5, 0.001));
    expect(ready.intervalIndex, 0);

    final warmUp = sprintPhase(
      started: true,
      elapsed: grace,
      grace: grace,
      intervals: intervals,
    );
    expect(warmUp.kind, SprintPhaseKind.interval);
    expect(warmUp.intervalIndex, 0);
    expect(warmUp.progress, 0);

    final second = sprintPhase(
      started: true,
      elapsed: grace + const Duration(seconds: 2),
      grace: grace,
      intervals: intervals,
    );
    expect(second.kind, SprintPhaseKind.interval);
    expect(second.intervalIndex, 1);
    expect(second.number(2), 2);

    final done = sprintPhase(
      started: true,
      elapsed: grace + const Duration(seconds: 3),
      grace: grace,
      intervals: intervals,
    );
    expect(done.kind, SprintPhaseKind.done);
  });

  testWidgets('start, grace, intervals, and stop use the filling ring', (
    tester,
  ) async {
    List<LoggedInterval>? result;
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return FilledButton(
              onPressed: () async {
                opened = true;
                result = await Navigator.of(context).push<List<LoggedInterval>>(
                  MaterialPageRoute(
                    builder: (context) => const SprintTimerScreen(
                      grace: Duration(seconds: 4),
                      intervals: intervals,
                    ),
                  ),
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Warm-up'), findsOneWidget);
    expect(find.text('8 km/h'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    expect(_progress(tester), 0);
    _expectCentered(tester);

    await tester.tap(find.text('Start'));
    await tester.pump();
    expect(find.text('Get ready'), findsOneWidget);
    expect(find.text('Next: Warm-up'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Get ready'), findsOneWidget);
    expect(_progress(tester), closeTo(0.5, 0.05));
    expect(sprintRingSweep(_progress(tester)), greaterThan(0));

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();
    expect(opened, isTrue);
    expect(result, isNull);
    expect(find.text('Open'), findsOneWidget);

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Warm-up'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('8 km/h'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Interval'), findsOneWidget);
    expect(find.text('2/2'), findsOneWidget);
    expect(find.text('14 km/h'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(result, intervals);
    expect(find.text('Open'), findsOneWidget);
  });
}

double _progress(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.byKey(const Key('sprint-ring')),
  );
  return (paint.painter! as SprintRingPainter).progress;
}

void _expectCentered(WidgetTester tester) {
  final screen = tester.getRect(find.byType(Scaffold));
  final appBar = tester.getRect(find.byType(AppBar));
  final title = tester.getRect(find.text('Warm-up'));
  final speed = tester.getRect(find.text('8 km/h'));
  final count = tester.getRect(find.text('1/2'));
  final ring = tester.getRect(find.byKey(const Key('sprint-ring')));
  final countdown = tester.getRect(find.text('2'));
  final button = tester.getRect(find.widgetWithText(FilledButton, 'Start'));
  final barTitle = tester.getRect(find.text('Sprint'));

  for (final rect in [title, speed, count, ring, button, barTitle]) {
    expect(rect.center.dx, closeTo(screen.center.dx, 1));
  }
  expect(countdown.center.dx, closeTo(ring.center.dx, 1));
  expect(countdown.center.dy, closeTo(ring.center.dy, 1));

  final gapAbove = title.top - appBar.bottom;
  final gapBelow = screen.bottom - button.bottom;
  expect(gapAbove, greaterThan(24));
  expect((gapAbove - gapBelow).abs(), lessThan(8));
}
