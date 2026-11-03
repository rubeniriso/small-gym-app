import 'package:flutter/material.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/l10n/app_strings.dart';

class PrescriptionLines extends StatelessWidget {
  const PrescriptionLines({super.key, required this.exercise});

  final PrescribedExercise exercise;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    if (exercise.exercise.kind == ExerciseKind.sprinting &&
        exercise.intervals.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < exercise.intervals.length; index++)
            Text(s.sprintLine(exercise.intervals[index], index)),
        ],
      );
    }
    return Text(s.prescription(exercise));
  }
}
