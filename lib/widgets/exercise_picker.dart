import 'package:flutter/material.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/widgets/exercise_creator.dart';

Future<Exercise?> showExercisePicker(
  BuildContext context,
  List<Exercise> exercises, {
  String title = 'Add exercise',
  Future<Exercise?> Function(ExerciseDraft draft)? onCreate,
}) {
  return showModalBottomSheet<Exercise>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) =>
        ExercisePicker(exercises: exercises, title: title, onCreate: onCreate),
  );
}

class ExercisePicker extends StatefulWidget {
  const ExercisePicker({
    super.key,
    required this.exercises,
    this.title = 'Add exercise',
    this.onCreate,
  });

  final List<Exercise> exercises;
  final String title;
  final Future<Exercise?> Function(ExerciseDraft draft)? onCreate;

  @override
  State<ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends State<ExercisePicker> {
  MuscleGroup? _group;
  Equipment? _equipment;

  bool _matches(Exercise exercise) {
    if (_group != null && exercise.muscleGroup != _group) {
      return false;
    }
    if (_equipment != null && exercise.equipment != _equipment) {
      return false;
    }
    return true;
  }

  Future<void> _create() async {
    final draft = await showExerciseCreator(
      context,
      initialGroup: _group,
      initialEquipment: _equipment,
    );
    if (!mounted || draft == null) {
      return;
    }
    final created = await widget.onCreate!(draft);
    if (!mounted || created == null) {
      return;
    }
    Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.s;
    final title = widget.title == 'Add exercise'
        ? s.text('Add exercise')
        : widget.title;
    final filtered = [
      for (final exercise in widget.exercises)
        if (_matches(exercise)) exercise,
    ];
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                if (widget.onCreate != null)
                  IconButton(
                    key: const Key('picker-create-exercise'),
                    tooltip: s.text('Add exercise'),
                    onPressed: _create,
                    icon: const Icon(Icons.add),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      key: const Key('muscle-all'),
                      label: Text(s.text('All')),
                      selected: _group == null,
                      onSelected: (_) => setState(() => _group = null),
                    ),
                    for (final group in MuscleGroup.values)
                      ChoiceChip(
                        key: Key('muscle-${group.name}'),
                        label: Text(s.muscleGroup(group)),
                        selected: _group == group,
                        onSelected: (_) => setState(() => _group = group),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  s.text('Equipment'),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      key: const Key('equipment-all'),
                      label: Text(s.text('All')),
                      selected: _equipment == null,
                      onSelected: (_) => setState(() => _equipment = null),
                    ),
                    for (final equipment in Equipment.values)
                      ChoiceChip(
                        key: Key('equipment-${equipment.name}'),
                        label: Text(s.equipment(equipment)),
                        selected: _equipment == equipment,
                        onSelected: (_) =>
                            setState(() => _equipment = equipment),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      s.text(
                        _equipment == null
                            ? 'Nothing left in this group.'
                            : 'No exercises match.',
                      ),
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
            context.s.muscleGroup(group),
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
      title: Text(context.s.exerciseName(exercise)),
      subtitle: Text(context.s.exerciseDetail(exercise)),
      onTap: () => Navigator.pop(context, exercise),
    );
  }
}
