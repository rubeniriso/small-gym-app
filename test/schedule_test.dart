import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/schedule.dart';

void main() {
  final anchor = DateTime(2026, 11, 2);

  test('calendar days ignore daylight saving', () {
    expect(calendarDaysBetween(DateTime(2026, 3, 8), DateTime(2026, 3, 15)), 7);
    expect(addCalendarDays(DateTime(2026, 3, 8), 7), DateTime(2026, 3, 15));
  });

  test('the template covers 12 weeks of Monday, Wednesday, and Friday', () {
    expect(anchor.weekday, DateTime.monday);
    expect(
      templateWindow(anchor, DateTime(2026, 11, 1)),
      TemplateWindow.before,
    );
    expect(templateWindow(anchor, anchor), TemplateWindow.inside);
    expect(templateSequenceIndex(anchor, anchor), 0);
    expect(templateSequenceIndex(anchor, DateTime(2026, 11, 3)), isNull);
    expect(templateSequenceIndex(anchor, DateTime(2026, 11, 4)), 1);
    expect(templateSequenceIndex(anchor, DateTime(2026, 11, 6)), 2);
    expect(templateSequenceIndex(anchor, DateTime(2026, 11, 9)), 3);

    final lastSunday = addCalendarDays(anchor, 83);
    expect(lastSunday.weekday, DateTime.sunday);
    expect(templateWindow(anchor, lastSunday), TemplateWindow.inside);
    expect(templateSequenceIndex(anchor, lastSunday), isNull);

    final lastFriday = addCalendarDays(anchor, 81);
    expect(lastFriday.weekday, DateTime.friday);
    expect(templateSequenceIndex(anchor, lastFriday), 35);

    final after = addCalendarDays(anchor, templateLengthDays);
    expect(templateWindow(anchor, after), TemplateWindow.after);
    expect(templateSequenceIndex(anchor, after), isNull);
  });
}
