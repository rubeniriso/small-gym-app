import 'package:flutter/material.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/sprint.dart';

class PrescriptionLines extends StatelessWidget {
  const PrescriptionLines({super.key, required this.exercise});

  final PrescribedExercise exercise;

  @override
  Widget build(BuildContext context) {
    if (exercise.exercise.kind == ExerciseKind.sprinting &&
        exercise.intervals.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < exercise.intervals.length; index++)
            Text(sprintObjective(exercise.intervals[index], index)),
        ],
      );
    }
    return Text(describePrescription(exercise));
  }
}
