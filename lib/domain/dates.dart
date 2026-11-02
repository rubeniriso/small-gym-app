DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

/// Adds calendar days without drifting across daylight-saving changes.
DateTime addCalendarDays(DateTime day, int days) {
  final start = dateOnly(day);
  final shifted = DateTime.utc(
    start.year,
    start.month,
    start.day,
  ).add(Duration(days: days));
  return DateTime(shifted.year, shifted.month, shifted.day);
}

int calendarDaysBetween(DateTime start, DateTime end) {
  final first = DateTime.utc(start.year, start.month, start.day);
  final second = DateTime.utc(end.year, end.month, end.day);
  return second.difference(first).inDays;
}

String formatIsoDate(DateTime value) {
  final day = dateOnly(value);
  final month = day.month.toString().padLeft(2, '0');
  final dayOfMonth = day.day.toString().padLeft(2, '0');
  return '${day.year}-$month-$dayOfMonth';
}

DateTime parseIsoDate(String value) {
  final parts = value.split('-');
  if (parts.length != 3) {
    throw ArgumentError.value(value, 'value', 'Expected a YYYY-MM-DD date.');
  }
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

const weekdayLabels = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

String weekdayLabel(int weekday) => weekdayLabels[weekday - 1];

const _months = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String formatLongDate(DateTime value) {
  final day = dateOnly(value);
  return '${weekdayLabel(day.weekday)}, ${_months[day.month - 1]} ${day.day}, ${day.year}';
}

DateTime upcomingMonday(DateTime from) {
  final day = dateOnly(from);
  final delta = (DateTime.monday - day.weekday) % 7;
  return addCalendarDays(day, delta);
}
