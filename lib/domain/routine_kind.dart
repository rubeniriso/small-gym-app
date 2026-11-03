/// A static routine follows the week. A dynamic routine is chosen each day.
/// A custom pattern repeats a numbered sequence on the calendar.
enum RoutineKind {
  staticWeek('static', 'Static'),
  dynamicDay('dynamic', 'Dynamic'),
  customPattern('pattern', 'Custom Pattern');

  const RoutineKind(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static RoutineKind fromStorage(String? value) {
    return RoutineKind.values.firstWhere(
      (kind) => kind.storageKey == value,
      orElse: () => RoutineKind.staticWeek,
    );
  }
}
