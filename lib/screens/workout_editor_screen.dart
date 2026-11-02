import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/data/gym_repository.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/sprint.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/exercise_picker.dart';
import 'package:gym_app/widgets/exercise_target_sheet.dart';

class WorkoutEditorScreen extends ConsumerStatefulWidget {
  const WorkoutEditorScreen({super.key, required this.workoutId});

  final int workoutId;

  @override
  ConsumerState<WorkoutEditorScreen> createState() =>
      _WorkoutEditorScreenState();
}

class _WorkoutEditorScreenState extends ConsumerState<WorkoutEditorScreen> {
  TextEditingController? _name;
  String? _savedName;

  @override
  void dispose() {
    _name?.dispose();
    super.dispose();
  }

  void _ensureName(String name) {
    if (_name != null) {
      return;
    }
    _savedName = name;
    _name = TextEditingController(text: name);
  }

  void _saveName() {
    final text = _name?.text.trim() ?? '';
    if (text.isEmpty || text == _savedName) {
      return;
    }
    _savedName = text;
    final notifier = ref.read(dataRevisionProvider.notifier);
    final pending = ref.read(repositoryProvider.future);
    unawaited(_persistName(pending, notifier, widget.workoutId, text));
  }

  Future<void> _persistName(
    Future<GymRepository> pending,
    DataRevision notifier,
    int workoutId,
    String name,
  ) async {
    final repository = await pending;
    await repository.renameWorkout(workoutId, name);
    notifier.bump();
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(workoutDetailsProvider(widget.workoutId));
    return DatabaseView(
      value: details,
      builder: (context, workout) {
        _ensureName(workout.name);
        final used = {
          for (final exercise in workout.exercises) exercise.exercise,
        };
        final remaining = [
          for (final exercise in Exercise.values)
            if (!used.contains(exercise)) exercise,
        ];
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              _saveName();
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _saveName(),
              ),
              const SizedBox(height: 16),
              if (workout.exercises.isEmpty)
                Text(
                  'Add an exercise.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              for (final exercise in workout.exercises)
                _ExerciseRow(
                  key: ValueKey(exercise.id),
                  exercise: exercise,
                  onVolume: (sets, reps) {
                    ref.mutate(
                      (repository) => repository.updateExercise(
                        id: exercise.id,
                        sets: sets,
                        reps: reps,
                      ),
                    );
                  },
                  onWeight: (weight) {
                    ref.mutate(
                      (repository) => repository.updateExercise(
                        id: exercise.id,
                        sets: exercise.sets,
                        reps: exercise.reps,
                        targetWeightKg: weight,
                        saveWeight: true,
                      ),
                    );
                  },
                  onJog: (minutes, speed) {
                    ref.mutate(
                      (repository) => repository.updateExercise(
                        id: exercise.id,
                        sets: exercise.sets,
                        reps: exercise.reps,
                        targetMinutes: minutes,
                        targetSpeedKmh: speed,
                        saveJog: true,
                      ),
                    );
                  },
                  onIntervals: (intervals) {
                    ref.mutate(
                      (repository) => repository.replaceSprintIntervals(
                        id: exercise.id,
                        intervals: intervals,
                      ),
                    );
                  },
                  onRemove: () {
                    ref.mutate(
                      (repository) => repository.removeExercise(exercise.id),
                    );
                  },
                ),
              if (remaining.isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(
                    onPressed: () => _addExercise(context, remaining),
                    child: const Text('Add exercise'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _addExercise(
    BuildContext context,
    List<Exercise> remaining,
  ) async {
    final picked = await showExercisePicker(context, remaining);
    if (picked == null || !context.mounted) {
      return;
    }
    final targets = await showExerciseTargets(context, picked);
    if (targets == null) {
      return;
    }
    await ref.mutate(
      (repository) => repository.addExercise(
        workoutId: widget.workoutId,
        exercise: picked,
        sets: targets.sets,
        reps: targets.reps,
        targetWeightKg: targets.weightKg,
        targetMinutes: targets.minutes,
        targetSpeedKmh: targets.speedKmh,
        intervals: targets.intervals,
      ),
    );
  }
}

class _ExerciseRow extends StatefulWidget {
  const _ExerciseRow({
    super.key,
    required this.exercise,
    required this.onVolume,
    required this.onWeight,
    required this.onJog,
    required this.onIntervals,
    required this.onRemove,
  });

  final WorkoutExerciseDetails exercise;
  final void Function(int sets, int reps) onVolume;
  final ValueChanged<double> onWeight;
  final void Function(int minutes, double speed) onJog;
  final ValueChanged<List<LoggedInterval>> onIntervals;
  final VoidCallback onRemove;

  @override
  State<_ExerciseRow> createState() => _ExerciseRowState();
}

class _ExerciseRowState extends State<_ExerciseRow> {
  late final TextEditingController _weight;
  late final TextEditingController _minutes;
  late final TextEditingController _speed;
  String? _error;

  @override
  void initState() {
    super.initState();
    _weight = TextEditingController(text: _kg(widget.exercise.targetWeightKg));
    _minutes = TextEditingController(
      text: widget.exercise.targetMinutes?.toString() ?? '',
    );
    _speed = TextEditingController(text: _kg(widget.exercise.targetSpeedKmh));
  }

  @override
  void didUpdateWidget(covariant _ExerciseRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(_weight, _kg(widget.exercise.targetWeightKg));
    _sync(_minutes, widget.exercise.targetMinutes?.toString() ?? '');
    _sync(_speed, _kg(widget.exercise.targetSpeedKmh));
  }

  void _sync(TextEditingController controller, String next) {
    if (controller.text != next) {
      controller.text = next;
    }
  }

  @override
  void dispose() {
    _weight.dispose();
    _minutes.dispose();
    _speed.dispose();
    super.dispose();
  }

  void _saveWeight() {
    final weight = tryParseKg(_weight.text);
    if (weight == null) {
      setState(() => _error = 'Enter a weight.');
      return;
    }
    setState(() => _error = null);
    if (weight == widget.exercise.targetWeightKg) {
      return;
    }
    widget.onWeight(weight);
  }

  Future<void> _editIntervals(BuildContext context) async {
    final targets = await showExerciseTargets(
      context,
      widget.exercise.exercise,
      intervals: widget.exercise.intervals,
      editing: true,
    );
    if (targets == null) {
      return;
    }
    widget.onIntervals(targets.intervals);
  }

  void _saveJog() {
    final minutes = int.tryParse(_minutes.text.trim());
    final speed = tryParseKg(_speed.text);
    if (minutes == null || minutes < 1) {
      setState(() => _error = 'Enter the minutes.');
      return;
    }
    if (speed == null) {
      setState(() => _error = 'Enter a speed.');
      return;
    }
    setState(() => _error = null);
    if (minutes == widget.exercise.targetMinutes &&
        speed == widget.exercise.targetSpeedKmh) {
      return;
    }
    widget.onJog(minutes, speed);
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exercise.exercise.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Remove exercise',
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          switch (exercise.exercise.kind) {
            ExerciseKind.jogging => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TargetField(
                  controller: _minutes,
                  label: 'Minutes',
                  onSubmitted: _saveJog,
                ),
                const SizedBox(height: 8),
                _TargetField(
                  controller: _speed,
                  label: 'Speed (km/h)',
                  decimal: true,
                  onSubmitted: _saveJog,
                ),
              ],
            ),
            ExerciseKind.sprinting => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (exercise.intervals.isEmpty)
                  Text(
                    'Add the warm-up and each interval.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  for (
                    var index = 0;
                    index < exercise.intervals.length;
                    index++
                  )
                    Text(sprintObjective(exercise.intervals[index], index)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => _editIntervals(context),
                    child: Text(
                      exercise.intervals.isEmpty
                          ? 'Add intervals'
                          : 'Edit intervals',
                    ),
                  ),
                ),
              ],
            ),
            ExerciseKind.strength => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Stepper(
                  label: 'Sets',
                  value: exercise.sets,
                  onChanged: (sets) => widget.onVolume(sets, exercise.reps),
                ),
                _Stepper(
                  label: 'Reps',
                  value: exercise.reps,
                  onChanged: (reps) => widget.onVolume(exercise.sets, reps),
                ),
                const SizedBox(height: 8),
                _TargetField(
                  controller: _weight,
                  label: 'Weight (kg)',
                  decimal: true,
                  onSubmitted: _saveWeight,
                ),
              ],
            ),
          },
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}

String _kg(double? value) => value == null ? '' : formatKg(value);

class _TargetField extends StatelessWidget {
  const _TargetField({
    required this.controller,
    required this.label,
    required this.onSubmitted,
    this.decimal = false,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onSubmitted;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: decimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(decimal ? r'[0-9.]' : r'[0-9]'),
        ),
      ],
      onSubmitted: (_) => onSubmitted(),
      onTapOutside: (_) => onSubmitted(),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 88, child: Text(label)),
        IconButton(
          tooltip: 'Fewer ${label.toLowerCase()}',
          onPressed: value <= 1 ? null : () => onChanged(value - 1),
          icon: const Icon(Icons.remove),
        ),
        SizedBox(width: 24, child: Text('$value', textAlign: TextAlign.center)),
        IconButton(
          tooltip: 'More ${label.toLowerCase()}',
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
