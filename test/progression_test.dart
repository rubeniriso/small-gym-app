import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';

void main() {
  test('more than 24 reps adds 2.5 kg and nothing else does', () {
    expect(
      prescribe(previousWeightKg: null, previousReps: null, startWeightKg: 20),
      20,
    );
    expect(
      prescribe(
        previousWeightKg: null,
        previousReps: null,
        startWeightKg: null,
      ),
      isNull,
    );
    expect(
      prescribe(previousWeightKg: 20, previousReps: 25, startWeightKg: 20),
      22.5,
    );
    expect(
      prescribe(previousWeightKg: 22.5, previousReps: 25, startWeightKg: 20),
      25,
    );
    expect(
      prescribe(previousWeightKg: 20, previousReps: 24, startWeightKg: 20),
      20,
    );
    expect(
      prescribe(previousWeightKg: 20, previousReps: 0, startWeightKg: 20),
      20,
    );
  });

  test('a custom kilogram or percent step replaces 2.5 kg', () {
    const fiveKilos = WeightIncrement(unit: IncrementUnit.kilograms, amount: 5);
    const tenPercent = WeightIncrement(unit: IncrementUnit.percent, amount: 10);
    expect(
      prescribe(
        previousWeightKg: 60,
        previousReps: 25,
        startWeightKg: 60,
        increment: fiveKilos,
      ),
      65,
    );
    expect(
      prescribe(
        previousWeightKg: 60,
        previousReps: 25,
        startWeightKg: 60,
        increment: tenPercent,
      ),
      66,
    );
    expect(
      prescribe(
        previousWeightKg: 60,
        previousReps: 25,
        startWeightKg: 60,
        increment: const WeightIncrement(
          unit: IncrementUnit.kilograms,
          amount: 0,
        ),
      ),
      60,
    );
  });
}
