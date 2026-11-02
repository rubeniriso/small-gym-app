import 'package:flutter/material.dart';
import 'package:gym_app/domain/exercise.dart';

Future<Exercise?> showExercisePicker(
  BuildContext context,
  List<Exercise> exercises,
) {
  return showModalBottomSheet<Exercise>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => ExercisePicker(exercises: exercises),
  );
}

class ExercisePicker extends StatefulWidget {
  const ExercisePicker({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  State<ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends State<ExercisePicker> {
  MuscleGroup? _group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = [
      for (final exercise in widget.exercises)
        if (_group == null || exercise.muscleGroup == _group) exercise,
    ];
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('Add exercise', style: theme.textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  key: const Key('muscle-all'),
                  label: const Text('All'),
                  selected: _group == null,
                  onSelected: (_) => setState(() => _group = null),
                ),
                for (final group in MuscleGroup.values)
                  ChoiceChip(
                    key: Key('muscle-${group.name}'),
                    label: Text(group.label),
                    selected: _group == group,
                    onSelected: (_) => setState(() => _group = group),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'Nothing left in this group.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    children: _rows(filtered),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _rows(List<Exercise> exercises) {
    if (_group != null) {
      return [for (final exercise in exercises) _tile(exercise)];
    }
    final rows = <Widget>[];
    for (final group in MuscleGroup.values) {
      final items = [
        for (final exercise in exercises)
          if (exercise.muscleGroup == group) exercise,
      ];
      if (items.isEmpty) {
        continue;
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
          child: Text(
            group.label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      );
      rows.addAll([for (final exercise in items) _tile(exercise)]);
    }
    return rows;
  }

  Widget _tile(Exercise exercise) {
    return ListTile(
      key: Key('exercise-${exercise.storageKey}'),
      title: Text(exercise.label),
      subtitle: Text(exercise.detail),
      onTap: () => Navigator.pop(context, exercise),
    );
  }
}
