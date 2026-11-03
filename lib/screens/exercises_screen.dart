import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/exercise_creator.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
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
    if (draft == null || !mounted) {
      return;
    }
    try {
      await ref.mutate(
        (repository) => repository.createExercise(
          name: draft.name,
          muscleGroup: draft.muscleGroup,
          equipment: draft.equipment,
          kind: draft.kind,
        ),
      );
    } on ArgumentError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.s.text(messageFor(error)))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(exerciseCatalogProvider);
    return DatabaseView(
      value: catalog,
      builder: (context, exercises) {
        final theme = Theme.of(context);
        final s = context.s;
        final filtered = [
          for (final exercise in exercises)
            if (_matches(exercise)) exercise,
        ];
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                            onSelected: (_) =>
                                setState(() => _equipment = null),
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
                IconButton(
                  key: const Key('catalog-create-exercise'),
                  tooltip: s.text('Add exercise'),
                  onPressed: _create,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  s.text(
                    _equipment == null
                        ? 'No exercises in this group.'
                        : 'No exercises match.',
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ..._rows(filtered),
          ],
        );
      },
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
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
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
      contentPadding: EdgeInsets.zero,
      key: Key('exercise-${exercise.storageKey}'),
      title: Text(context.s.exerciseName(exercise)),
      subtitle: Text(context.s.exerciseDetail(exercise)),
    );
  }
}
