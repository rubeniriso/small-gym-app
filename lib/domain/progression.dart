/// Rounds to the nearest tenth of a kilogram so 2.5 kg steps stay exact.
double roundKg(double kilograms) => (kilograms * 10).round() / 10;

String formatKg(double kilograms) {
  final rounded = roundKg(kilograms);
  if (rounded == rounded.roundToDouble()) {
    return rounded.toStringAsFixed(0);
  }
  return rounded.toStringAsFixed(1);
}

double? tryParseKg(String text) {
  final value = double.tryParse(text.trim());
  if (value == null || value < 0 || value.isNaN || value.isInfinite) {
    return null;
  }
  return roundKg(value);
}

/// Next weight for one lift in one routine.
///
/// The previous logged session of that lift is the only input. More than 24
/// reps adds 2.5 kg. Otherwise the weight stays. A finished 5×5 is 25 reps,
/// so the increase requires every rep. There is no deload. With no previous
/// session, the starting weight is used.
double? prescribe({
  required double? previousWeightKg,
  required int? previousReps,
  required double? startWeightKg,
}) {
  if (previousWeightKg == null) {
    return startWeightKg == null ? null : roundKg(startWeightKg);
  }
  if (previousReps != null && previousReps > 24) {
    return roundKg(previousWeightKg + 2.5);
  }
  return roundKg(previousWeightKg);
}
