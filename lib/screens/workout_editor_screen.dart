import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/data/gym_repository.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/sprint.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/duration_picker.dart';
import 'package:gym_app/widgets/exercise_creator.dart';
import 'package:gym_app/widgets/exercise_picker.dart';
import 'package:gym_app/widgets/exercise_target_sheet.dart';
import 'package:gym_app/widgets/gym_icons.dart';
import 'package:gym_app/widgets/increment_picker.dart';

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
          for (final exercise in Exercise.catalog)
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
                decoration: InputDecoration(
                  labelText: context.s.text('Name'),
                  border: const OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _saveName(),
              ),
              const SizedBox(height: 16),
              if (workout.exercises.isEmpty)
                Text(
                  context.s.text('Add an exercise.'),
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
                  onRest: (seconds) {
                    ref.mutate(
                      (repository) => repository.updateExercise(
                        id: exercise.id,
                        sets: exercise.sets,
                        reps: exercise.reps,
                        restSeconds: seconds,
                        saveRest: true,
                      ),
                    );
                  },
                  onIncrement: (increment) {
                    ref.mutate(
                      (repository) => repository.updateExercise(
                        id: exercise.id,
                        sets: exercise.sets,
                        reps: exercise.reps,
                        increment: increment,
                        saveIncrement: true,
                      ),
                    );
                  },
                  onJog: (durationSeconds, speed) {
                    ref.mutate(
                      (repository) => repository.updateExercise(
                        id: exercise.id,
                        sets: exercise.sets,
                        reps: exercise.reps,
                        targetDurationSeconds: durationSeconds,
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
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => _addExercise(context, remaining),
                    child: Text(context.s.text('Add exercise')),
                  ),
                  IconButton(
                    key: const Key('workout-create-exercise'),
                    tooltip: context.s.text('Add exercise'),
                    onPressed: () => _createExercise(context),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Exercise?> _persist(ExerciseDraft draft) async {
    try {
      return await ref.mutate(
        (repository) => repository.createExercise(
          name: draft.name,
          muscleGroup: draft.muscleGroup,
          equipment: draft.equipment,
          kind: draft.kind,
        ),
      );
    } on ArgumentError catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.s.errorMessage(error))));
      }
      return null;
    }
  }

  Future<void> _addExercise(
    BuildContext context,
    List<Exercise> remaining,
  ) async {
    final picked = await showExercisePicker(
      context,
      remaining,
      onCreate: _persist,
    );
    if (picked == null || !context.mounted) {
      return;
    }
    await _commit(picked);
  }

  Future<void> _createExercise(BuildContext context) async {
    final draft = await showExerciseCreator(context);
    if (draft == null || !context.mounted) {
      return;
    }
    final created = await _persist(draft);
    if (created == null || !context.mounted) {
      return;
    }
    await _commit(created);
  }

  Future<void> _commit(Exercise picked) async {
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
        targetDurationSeconds: targets.durationSeconds,
        targetSpeedKmh: targets.speedKmh,
        restSeconds: targets.restSeconds,
        increment: targets.increment,
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
    required this.onRest,
    required this.onIncrement,
    required this.onJog,
    required this.onIntervals,
    required this.onRemove,
  });

  final WorkoutExerciseDetails exercise;
  final void Function(int sets, int reps) onVolume;
  final ValueChanged<double> onWeight;
  final ValueChanged<int?> onRest;
  final ValueChanged<WeightIncrement?> onIncrement;
  final void Function(int durationSeconds, double speed) onJog;
  final ValueChanged<List<LoggedInterval>> onIntervals;
  final VoidCallback onRemove;

  @override
  State<_ExerciseRow> createState() => _ExerciseRowState();
}

class _ExerciseRowState extends State<_ExerciseRow> {
  late final TextEditingController _weight;
  late final TextEditingController _speed;
  var _duration = 0;
  var _editing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _weight = TextEditingController(text: _kg(widget.exercise.targetWeightKg));
    _duration = widget.exercise.targetDurationSeconds ?? 0;
    _speed = TextEditingController(text: _kg(widget.exercise.targetSpeedKmh));
  }

  @override
  void didUpdateWidget(covariant _ExerciseRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(_weight, _kg(widget.exercise.targetWeightKg));
    _sync(_speed, _kg(widget.exercise.targetSpeedKmh));
    if (widget.exercise.targetDurationSeconds !=
        oldWidget.exercise.targetDurationSeconds) {
      _duration = widget.exercise.targetDurationSeconds ?? 0;
    }
  }

  void _sync(TextEditingController controller, String next) {
    if (controller.text != next) {
      controller.text = next;
    }
  }

  @override
  void dispose() {
    _weight.dispose();
    _speed.dispose();
    super.dispose();
  }

  bool _saveWeight() {
    final weight = tryParseKg(_weight.text);
    if (weight == null) {
      setState(() => _error = 'Enter a weight.');
      return false;
    }
    setState(() => _error = null);
    if (weight != widget.exercise.targetWeightKg) {
      widget.onWeight(weight);
    }
    return true;
  }

  void _saveRest(int? seconds) {
    setState(() => _error = null);
    if (seconds == widget.exercise.restSeconds) {
      return;
    }
    widget.onRest(seconds);
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

  bool _saveJog() {
    final speed = tryParseKg(_speed.text);
    if (_duration < 1) {
      setState(() => _error = 'Enter a duration.');
      return false;
    }
    if (speed == null) {
      setState(() => _error = 'Enter a speed.');
      return false;
    }
    setState(() => _error = null);
    if (_duration != widget.exercise.targetDurationSeconds ||
        speed != widget.exercise.targetSpeedKmh) {
      widget.onJog(_duration, speed);
    }
    return true;
  }

  void _toggleEdit() {
    if (!_editing) {
      setState(() {
        _error = null;
        _editing = true;
      });
      return;
    }
    final saved = switch (widget.exercise.exercise.kind) {
      ExerciseKind.strength => _saveWeight(),
      ExerciseKind.jogging => _saveJog(),
      ExerciseKind.sprinting => true,
    };
    if (!saved) {
      return;
    }
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final s = context.s;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s.exerciseName(exercise.exercise),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (_editing)
                IconButton(
                  tooltip: s.text('Remove exercise'),
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              TextButton(
                onPressed: _toggleEdit,
                child: Text(_editing ? s.text('Done') : s.text('Edit')),
              ),
            ],
          ),
          if (!_editing)
            _ExerciseSummary(exercise: exercise)
          else
            switch (exercise.exercise.kind) {
              ExerciseKind.jogging => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DurationField(
                    label: s.text('Duration'),
                    seconds: _duration == 0 ? null : _duration,
                    maxMinutes: jogMaxMinutes,
                    onChanged: (seconds) {
                      setState(() => _duration = seconds ?? 0);
                      _saveJog();
                    },
                  ),
                  const SizedBox(height: 8),
                  _TargetField(
                    controller: _speed,
                    label: s.text('Speed (km/h)'),
                    decimal: true,
                    onSubmitted: () {
                      _saveJog();
                    },
                  ),
                ],
              ),
              ExerciseKind.sprinting => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exercise.intervals.isEmpty)
                    Text(
                      s.text('Add the warm-up and each interval.'),
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
                      Text(s.sprintLine(exercise.intervals[index], index)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => _editIntervals(context),
                      child: Text(
                        exercise.intervals.isEmpty
                            ? s.text('Add intervals')
                            : s.text('Edit intervals'),
                      ),
                    ),
                  ),
                ],
              ),
              ExerciseKind.strength => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Stepper(
                    label: s.text('Sets'),
                    value: exercise.sets,
                    onChanged: (sets) => widget.onVolume(sets, exercise.reps),
                  ),
                  _Stepper(
                    label: s.text('Reps'),
                    value: exercise.reps,
                    onChanged: (reps) => widget.onVolume(exercise.sets, reps),
                  ),
                  const SizedBox(height: 8),
                  _TargetField(
                    controller: _weight,
                    label: s.text('Weight (kg)'),
                    decimal: true,
                    onSubmitted: () {
                      _saveWeight();
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      DurationField(
                        label: s.text('Rest'),
                        seconds: exercise.restSeconds,
                        maxMinutes: restMaxMinutes,
                        clearable: true,
                        compact: true,
                        icon: const StopwatchIcon(),
                        onChanged: _saveRest,
                      ),
                      const SizedBox(width: 16),
                      IncrementField(
                        label: s.text('Weight increments'),
                        increment: exercise.increment,
                        clearable: true,
                        compact: true,
                        onChanged: widget.onIncrement,
                      ),
                    ],
                  ),
                ],
              ),
            },
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                s.text(_error!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}

String _kg(double? value) => value == null ? '' : formatKg(value);

class _ExerciseSummary extends StatelessWidget {
  const _ExerciseSummary({required this.exercise});

  final WorkoutExerciseDetails exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.s;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return switch (exercise.exercise.kind) {
      ExerciseKind.jogging => Text(
        s.jogLine(
          durationSeconds: exercise.targetDurationSeconds,
          speedKmh: exercise.targetSpeedKmh,
        ),
        style: muted,
      ),
      ExerciseKind.sprinting =>
        exercise.intervals.isEmpty
            ? Text(s.text('Add the warm-up and each interval.'), style: muted)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (
                    var index = 0;
                    index < exercise.intervals.length;
                    index++
                  )
                    Text(s.sprintLine(exercise.intervals[index], index)),
                ],
              ),
      ExerciseKind.strength => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_strengthSummary(exercise), style: muted),
          if (exercise.restSeconds != null || exercise.increment != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  if (exercise.restSeconds != null) ...[
                    const StopwatchIcon(),
                    const SizedBox(width: 8),
                    Text(formatDuration(exercise.restSeconds!)),
                    const SizedBox(width: 16),
                  ],
                  if (exercise.increment != null) ...[
                    const PlateUpIcon(),
                    const SizedBox(width: 8),
                    Text(formatIncrement(exercise.increment!)),
                  ],
                ],
              ),
            ),
        ],
      ),
    };
  }
}

String _strengthSummary(WorkoutExerciseDetails exercise) {
  final volume = '${exercise.sets} × ${exercise.reps}';
  final weight = exercise.targetWeightKg;
  if (weight == null) {
    return volume;
  }
  return '$volume · ${formatKg(weight)} kg';
}

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
    final s = context.s;
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 88),
          child: Text(label),
        ),
        IconButton(
          tooltip: s.fewer(label),
          onPressed: value <= 1 ? null : () => onChanged(value - 1),
          icon: const Icon(Icons.remove),
        ),
        SizedBox(width: 24, child: Text('$value', textAlign: TextAlign.center)),
        IconButton(
          tooltip: s.more(label),
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
