import 'package:gym_app/domain/dates.dart';

const templateWeeks = 12;
const templateLengthDays = templateWeeks * 7;
const templateSessionCount = templateWeeks * 3;

enum TemplateWindow { before, inside, after }

bool isTemplateTrainingWeekday(int weekday) {
  return weekday == DateTime.monday ||
      weekday == DateTime.wednesday ||
      weekday == DateTime.friday;
}

TemplateWindow templateWindow(DateTime anchorMonday, DateTime day) {
  final start = dateOnly(anchorMonday);
  final current = dateOnly(day);
  if (current.isBefore(start)) {
    return TemplateWindow.before;
  }
  final end = addCalendarDays(start, templateLengthDays);
  if (!current.isBefore(end)) {
    return TemplateWindow.after;
  }
  return TemplateWindow.inside;
}

/// Slot 0 is week 1 Monday, then Wednesday, Friday, week 2 Monday, and so on.
///
/// Returns null on a rest weekday or outside the 12 weeks.
int? templateSequenceIndex(DateTime anchorMonday, DateTime day) {
  if (templateWindow(anchorMonday, day) != TemplateWindow.inside) {
    return null;
  }
  final current = dateOnly(day);
  final dayOffset = switch (current.weekday) {
    DateTime.monday => 0,
    DateTime.wednesday => 1,
    DateTime.friday => 2,
    _ => null,
  };
  if (dayOffset == null) {
    return null;
  }
  final week = calendarDaysBetween(dateOnly(anchorMonday), current) ~/ 7;
  return week * 3 + dayOffset;
}
