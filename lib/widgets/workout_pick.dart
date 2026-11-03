import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';

class WorkoutPick extends ConsumerWidget {
  const WorkoutPick({
    super.key,
    required this.routineId,
    required this.day,
    required this.workouts,
    required this.selectedId,
  });

  final int routineId;
  final DateTime day;
  final List<WorkoutSummary> workouts;
  final int selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (workouts.length < 2) {
      return const SizedBox.shrink();
    }
    final s = context.s;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final workout in workouts)
          ChoiceChip(
            label: Text(s.workoutName(workout.name)),
            selected: workout.id == selectedId,
            onSelected: (_) {
              ref.mutate(
                (repository) => repository.pickWorkout(
                  routineId: routineId,
                  day: day,
                  workoutId: workout.id,
                ),
              );
            },
          ),
      ],
    );
  }
}
