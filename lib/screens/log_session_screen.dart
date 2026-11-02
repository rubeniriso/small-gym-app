import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/sprint.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/screens/sprint_timer_screen.dart';
import 'package:gym_app/widgets/database_view.dart';

class LogSessionScreen extends ConsumerStatefulWidget {
  const LogSessionScreen({super.key, this.routineId});

  final int? routineId;

  @override
  ConsumerState<LogSessionScreen> createState() => _LogSessionScreenState();
}

class _LogSessionScreenState extends ConsumerState<LogSessionScreen> {
  LogFormData? _form;
  TodayView? _unavailable;
  var _loading = true;
  var _saving = false;
  String? _error;
  final _weights = <Exercise, TextEditingController>{};
  final _reps = <Exercise, List<TextEditingController>>{};
  final _speeds = <Exercise, TextEditingController>{};
  final _minutes = <Exercise, TextEditingController>{};
  final _completed = <Exercise, List<LoggedInterval>>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repository = await ref.read(repositoryProvider.future);
    final now = ref.read(clockProvider)();
    final home = await repository.loadHome(now, routineId: widget.routineId);
    final form = await repository.loadLogForm(now, routineId: widget.routineId);
    if (!mounted) {
      return;
    }
    if (form != null) {
      for (final exercise in form.exercises) {
        _bindExercise(exercise);
      }
    }
    setState(() {
      _form = form;
      _unavailable = form == null ? home.today : null;
      _loading = false;
    });
  }

  void _bindExercise(LogExerciseSeed exercise) {
    switch (exercise.exercise.kind) {
      case ExerciseKind.strength:
        final weight = exercise.weightKg;
        _weights[exercise.exercise] = TextEditingController(
          text: weight == null ? '' : formatKg(weight),
        );
        _reps[exercise.exercise] = [
          for (final reps in exercise.reps)
            TextEditingController(text: '$reps'),
        ];
      case ExerciseKind.jogging:
        final speed = exercise.speedKmh;
        final minutes = exercise.durationSeconds;
        _speeds[exercise.exercise] = TextEditingController(
          text: speed == null ? '' : formatKg(speed),
        );
        _minutes[exercise.exercise] = TextEditingController(
          text: minutes == null ? '' : '${minutes ~/ 60}',
        );
      case ExerciseKind.sprinting:
        final completed = exercise.completed;
        if (completed != null) {
          _completed[exercise.exercise] = completed;
        }
    }
  }

  Future<void> _openTimer(LogExerciseSeed exercise) async {
    if (exercise.plan.isEmpty) {
      return;
    }
    final result = await Navigator.of(context).push<List<LoggedInterval>>(
      MaterialPageRoute<List<LoggedInterval>>(
        builder: (context) => SprintTimerScreen(intervals: exercise.plan),
      ),
    );
    if (!mounted || result == null) {
      return;
    }
    setState(() {
      _completed[exercise.exercise] = result;
      _error = null;
    });
  }

  @override
  void dispose() {
    for (final controller in [
      ..._weights.values,
      ..._speeds.values,
      ..._minutes.values,
    ]) {
      controller.dispose();
    }
    for (final controllers in _reps.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _save() async {
    final form = _form;
    if (form == null || _saving) {
      return;
    }
    final lifts = <LoggedLift>[];
    for (final exercise in form.exercises) {
      final lift = _readLift(exercise);
      if (lift == null) {
        return;
      }
      lifts.add(lift);
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.mutate(
        (repository) => repository.logSession(
          routineId: form.routineId,
          loggedOn: form.day,
          workoutId: form.workoutId,
          trainingSlotId: form.trainingSlotId,
          lifts: lifts,
        ),
      );
    } on ArgumentError catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
        _error = messageFor(error);
      });
      return;
    }
    if (!mounted) {
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }
    final form = _form;
    if (form == null) {
      return Center(child: Text(_unavailableMessage(_unavailable)));
    }
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(form.workoutName, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  formatLongDate(form.day),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                for (final exercise in form.exercises) ...[
                  Text(
                    exercise.exercise.label,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ..._fields(exercise),
                  const SizedBox(height: 8),
                ],
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(form.updating ? 'Update session' : 'Save'),
            ),
          ),
        ),
      ],
    );
  }

  LoggedLift? _readLift(LogExerciseSeed exercise) {
    switch (exercise.exercise.kind) {
      case ExerciseKind.strength:
        final weight = tryParseKg(_weights[exercise.exercise]!.text);
        if (weight == null) {
          setState(() => _error = 'Enter a weight for every exercise.');
          return null;
        }
        final reps = <int>[];
        for (final controller in _reps[exercise.exercise]!) {
          final value = int.tryParse(controller.text.trim());
          if (value == null || value < 0) {
            setState(() => _error = 'Enter reps for every set.');
            return null;
          }
          reps.add(value);
        }
        return LoggedLift(
          exercise: exercise.exercise,
          weightKg: weight,
          reps: reps,
        );
      case ExerciseKind.jogging:
        final minutes = int.tryParse(_minutes[exercise.exercise]!.text.trim());
        final speed = tryParseKg(_speeds[exercise.exercise]!.text);
        if (minutes == null || minutes <= 0) {
          setState(() => _error = 'Enter the minutes.');
          return null;
        }
        if (speed == null) {
          setState(() => _error = 'Enter a speed.');
          return null;
        }
        return LoggedLift(
          exercise: exercise.exercise,
          weightKg: 0,
          reps: const [],
          speedKmh: speed,
          durationSeconds: minutes * 60,
        );
      case ExerciseKind.sprinting:
        if (exercise.plan.isEmpty) {
          setState(() => _error = 'Add sprint intervals in the workout.');
          return null;
        }
        final intervals = _completed[exercise.exercise];
        if (intervals == null || intervals.isEmpty) {
          setState(() => _error = 'Run the sprint timer.');
          return null;
        }
        return LoggedLift(
          exercise: exercise.exercise,
          weightKg: 0,
          reps: const [],
          intervals: intervals,
        );
    }
  }

  List<Widget> _fields(LogExerciseSeed exercise) {
    switch (exercise.exercise.kind) {
      case ExerciseKind.strength:
        return [
          _numberField(
            controller: _weights[exercise.exercise]!,
            label: 'Weight (kg)',
            decimal: true,
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < exercise.sets; index++) ...[
            _numberField(
              controller: _reps[exercise.exercise]![index],
              label: 'Set ${index + 1} reps',
            ),
            const SizedBox(height: 8),
          ],
        ];
      case ExerciseKind.jogging:
        return [
          _numberField(
            controller: _minutes[exercise.exercise]!,
            label: 'Minutes',
          ),
          const SizedBox(height: 8),
          _numberField(
            controller: _speeds[exercise.exercise]!,
            label: 'Speed (km/h)',
            decimal: true,
          ),
          const SizedBox(height: 8),
        ];
      case ExerciseKind.sprinting:
        final done = _completed[exercise.exercise] != null;
        return [
          if (exercise.plan.isEmpty)
            const Text(
              'Add sprint intervals in the workout.',
              textAlign: TextAlign.center,
            )
          else
            for (var index = 0; index < exercise.plan.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  sprintObjective(exercise.plan[index], index),
                  textAlign: TextAlign.center,
                ),
              ),
          if (done)
            const Text('Sprint complete.', textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: exercise.plan.isEmpty
                ? const SizedBox.shrink()
                : FilledButton(
                    onPressed: () => _openTimer(exercise),
                    child: Text(done ? 'Run again' : 'Start'),
                  ),
          ),
          const SizedBox(height: 8),
        ];
    }
  }
}

Widget _numberField({
  required TextEditingController controller,
  required String label,
  bool decimal = false,
}) {
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
      FilteringTextInputFormatter.allow(RegExp(decimal ? r'[0-9.]' : r'[0-9]')),
    ],
  );
}

String _unavailableMessage(TodayView? today) {
  return switch (today) {
    null || TodayNone() => 'No current routine.',
    TodayRest() => 'Rest',
    TodayNoSession() => 'This plan has no session today.',
    TodayNeedsWorkout() => 'Choose a workout for today.',
    TodayWorkout() => 'Log session',
  };
}
