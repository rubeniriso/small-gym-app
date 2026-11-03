import 'package:gym_app/domain/models.dart';

/// Rounds to the nearest hundredth of a kilogram.
double roundKg(double kilograms) => (kilograms * 100).round() / 100;

String formatKg(double kilograms) {
  final rounded = roundKg(kilograms);
  if (rounded == rounded.roundToDouble()) {
    return rounded.toStringAsFixed(0);
  }
  final text = rounded.toStringAsFixed(2);
  if (text.endsWith('0')) {
    return rounded.toStringAsFixed(1);
  }
  return text;
}

String formatIncrement(WeightIncrement increment) {
  final amount = formatKg(increment.amount);
  return switch (increment.unit) {
    IncrementUnit.kilograms => '$amount kg',
    IncrementUnit.percent => '$amount%',
  };
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
/// reps adds [increment]. Kilograms are added. A percent is that share of the
/// previous weight. An amount of zero leaves the weight where it is. A
/// finished 5×5 is 25 reps, so the increase requires every rep. There is no
/// deload. With no previous session, the starting weight is used.
double? prescribe({
  required double? previousWeightKg,
  required int? previousReps,
  required double? startWeightKg,
  WeightIncrement increment = standardIncrement,
}) {
  if (previousWeightKg == null) {
    return startWeightKg == null ? null : roundKg(startWeightKg);
  }
  if (previousReps != null && previousReps > 24 && increment.amount > 0) {
    final next = switch (increment.unit) {
      IncrementUnit.kilograms => previousWeightKg + increment.amount,
      IncrementUnit.percent => previousWeightKg * (1 + increment.amount / 100),
    };
    return roundKg(next);
  }
  return roundKg(previousWeightKg);
}
