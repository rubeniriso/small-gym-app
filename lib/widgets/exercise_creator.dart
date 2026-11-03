import 'package:flutter/material.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/l10n/app_strings.dart';

class ExerciseDraft {
  const ExerciseDraft({
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.kind,
  });

  final String name;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final ExerciseKind kind;
}

Future<ExerciseDraft?> showExerciseCreator(
  BuildContext context, {
  MuscleGroup? initialGroup,
  Equipment? initialEquipment,
}) {
  return showDialog<ExerciseDraft>(
    context: context,
    builder: (context) => _ExerciseCreator(
      initialGroup: initialGroup,
      initialEquipment: initialEquipment,
    ),
  );
}

class _ExerciseCreator extends StatefulWidget {
  const _ExerciseCreator({
    required this.initialGroup,
    required this.initialEquipment,
  });

  final MuscleGroup? initialGroup;
  final Equipment? initialEquipment;

  @override
  State<_ExerciseCreator> createState() => _ExerciseCreatorState();
}

class _ExerciseCreatorState extends State<_ExerciseCreator> {
  final _name = TextEditingController();
  late MuscleGroup _group;
  late Equipment _equipment;
  var _cardio = ExerciseKind.jogging;
  String? _error;

  @override
  void initState() {
    super.initState();
    _group = widget.initialGroup ?? MuscleGroup.chest;
    _equipment =
        widget.initialEquipment ??
        (_group == MuscleGroup.cardio ? Equipment.none : Equipment.barbell);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (name.isEmpty) {
      setState(() => _error = context.s.text('Enter a name.'));
      return;
    }
    final taken = Exercise.catalog.any(
      (exercise) => exercise.label.toLowerCase() == name.toLowerCase(),
    );
    if (taken) {
      setState(() => _error = context.s.text('That exercise already exists.'));
      return;
    }
    final cardio = _group == MuscleGroup.cardio;
    Navigator.pop(
      context,
      ExerciseDraft(
        name: name,
        muscleGroup: cardio ? MuscleGroup.cardio : _group,
        equipment: _equipment,
        kind: cardio ? _cardio : ExerciseKind.strength,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.s;
    return AlertDialog(
      title: Text(s.text('New exercise')),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                key: const Key('exercise-name'),
                controller: _name,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: s.text('Name'),
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 16),
              Text(s.text('Muscle group'), style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final group in MuscleGroup.values)
                    ChoiceChip(
                      key: Key('new-muscle-${group.name}'),
                      label: Text(s.muscleGroup(group)),
                      selected: _group == group,
                      onSelected: (_) => setState(() {
                        if (group == MuscleGroup.cardio && _group != group) {
                          _equipment = Equipment.none;
                        }
                        _group = group;
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (_group == MuscleGroup.cardio) ...[
                Text(s.text('Type'), style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final kind in const [
                      ExerciseKind.jogging,
                      ExerciseKind.sprinting,
                    ])
                      ChoiceChip(
                        key: Key('new-kind-${kind.name}'),
                        label: Text(
                          s.exerciseName(
                            kind == ExerciseKind.jogging
                                ? Exercise.jogging
                                : Exercise.sprinting,
                          ),
                        ),
                        selected: _cardio == kind,
                        onSelected: (_) => setState(() => _cardio = kind),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Text(s.text('Equipment'), style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final equipment in Equipment.values)
                    ChoiceChip(
                      key: Key('new-equipment-${equipment.name}'),
                      label: Text(s.equipment(equipment)),
                      selected: _equipment == equipment,
                      onSelected: (_) => setState(() => _equipment = equipment),
                    ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.text('Cancel')),
        ),
        TextButton(
          key: const Key('exercise-save'),
          onPressed: _save,
          child: Text(s.text('Save')),
        ),
      ],
    );
  }
}
