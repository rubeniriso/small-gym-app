import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/strength_set_row.dart';

class AutopilotScreen extends ConsumerStatefulWidget {
  const AutopilotScreen({super.key, this.routineId});

  final int? routineId;

  @override
  ConsumerState<AutopilotScreen> createState() => _AutopilotScreenState();
}

class _Step {
  _Step({
    required this.exercise,
    required this.setIndex,
    required this.setCount,
    required this.placeholderKg,
    required this.placeholderReps,
    required this.restSeconds,
    required this.targetReps,
    required this.done,
    this.weight,
    this.reps,
  }) : edited = done;

  final Exercise exercise;
  final int setIndex;
  final int setCount;
  final double placeholderKg;
  final int placeholderReps;
  final int restSeconds;
  final int targetReps;
  double? weight;
  int? reps;
  bool done;
  bool edited;

  double get displayKg => weight ?? placeholderKg;
  int get displayReps => reps ?? placeholderReps;
}

enum _Phase { perform, rest, finished }

class _AutopilotScreenState extends ConsumerState<AutopilotScreen>
    with SingleTickerProviderStateMixin {
  LogFormData? _form;
  TodayView? _unavailable;
  var _loading = true;
  final _steps = <_Step>[];
  var _index = 0;
  var _phase = _Phase.perform;
  String? _error;
  late final Ticker _ticker;
  var _elapsed = Duration.zero;
  var _budget = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      if (!mounted || _phase != _Phase.rest) {
        return;
      }
      if (elapsed >= _budget) {
        _ticker.stop();
        setState(() {
          _elapsed = _budget;
          _goToNextSet();
        });
        return;
      }
      setState(() => _elapsed = elapsed);
    });
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
    final steps = <_Step>[];
    if (form != null) {
      for (final exercise in form.exercises) {
        if (exercise.exercise.kind != ExerciseKind.strength) {
          continue;
        }
        for (var index = 0; index < exercise.strengthSets.length; index++) {
          final set = exercise.strengthSets[index];
          steps.add(
            _Step(
              exercise: exercise.exercise,
              setIndex: index,
              setCount: exercise.sets,
              placeholderKg: set.placeholderKg,
              placeholderReps: set.placeholderReps,
              restSeconds: exercise.restSeconds,
              targetReps: exercise.targetReps,
              done: set.done,
              weight: set.loggedKg,
              reps: set.loggedReps,
            ),
          );
        }
      }
    }
    setState(() {
      _form = form;
      _unavailable = form == null ? home.today : null;
      _steps.addAll(steps);
      _loading = false;
      if (steps.isEmpty && form != null) {
        _phase = _Phase.finished;
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _next() {
    final step = _steps[_index];
    _elapsed = Duration.zero;
    _budget = Duration(seconds: step.restSeconds);
    setState(() => _phase = _Phase.rest);
    _ticker.stop();
    _ticker.start();
  }

  void _addRest(int seconds) {
    setState(() => _budget += Duration(seconds: seconds));
  }

  void _skipRest() {
    _ticker.stop();
    setState(_goToNextSet);
  }

  void _goToNextSet() {
    if (_index < _steps.length - 1) {
      _index += 1;
      _phase = _Phase.perform;
      _error = null;
    } else {
      _phase = _Phase.finished;
    }
  }

  Future<void> _edit(LogFormData form, _Step step) async {
    final edited = await editStrengthSet(
      context,
      weightKg: step.displayKg,
      reps: step.displayReps,
    );
    if (!mounted || edited == null) {
      return;
    }
    setState(() {
      step.weight = edited.weightKg;
      step.reps = edited.reps;
      step.edited = true;
      _error = null;
    });
    if (step.done) {
      await _persist(form, step);
    }
  }

  Future<void> _toggle(LogFormData form, _Step step) async {
    if (step.done) {
      await ref.mutate(
        (repository) => repository.clearStrengthSet(
          routineId: form.routineId,
          loggedOn: form.day,
          exercise: step.exercise,
          setIndex: step.setIndex,
        ),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        step.done = false;
        _error = null;
      });
      return;
    }
    await _persist(form, step);
  }

  Future<void> _persist(LogFormData form, _Step step) async {
    try {
      await ref.mutate(
        (repository) => repository.saveStrengthSet(
          routineId: form.routineId,
          loggedOn: form.day,
          workoutId: form.workoutId,
          trainingSlotId: form.trainingSlotId,
          exercise: step.exercise,
          targetReps: step.targetReps,
          setIndex: step.setIndex,
          weightKg: step.displayKg,
          reps: step.displayReps,
        ),
      );
    } on ArgumentError catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = context.s.errorMessage(error));
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      step.done = true;
      step.weight ??= step.placeholderKg;
      step.reps ??= step.placeholderReps;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }
    final form = _form;
    final s = context.s;
    if (form == null) {
      return Center(child: Text(s.todayMessage(_unavailable)));
    }
    if (_steps.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            s.text(
              'Autopilot is for strength sets. Intervals stay on the log.',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final theme = Theme.of(context);
    final confirming = _phase == _Phase.perform
        ? null
        : _steps[_index.clamp(0, _steps.length - 1)];
    final current = _steps[_index.clamp(0, _steps.length - 1)];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          s.workoutName(form.workoutName),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        if (_phase == _Phase.perform) ...[
          Text(
            s.exerciseName(current.exercise),
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            s.setOf(current.setIndex + 1, current.setCount),
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            strengthSetLabel(current.placeholderKg, current.placeholderReps),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton(onPressed: _next, child: Text(s.text('Next'))),
        ] else ...[
          if (_phase == _Phase.rest) ...[
            Text(s.text('Rest'), style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              _clock(_budget - _elapsed),
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final extra in const [5, 10, 30]) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _addRest(extra),
                      child: Text('+$extra'),
                    ),
                  ),
                  if (extra != 30) const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _skipRest,
                child: Text(s.text('Skip')),
              ),
            ),
          ] else
            Text(s.text('Last set'), style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(
            s.exerciseName(confirming!.exercise),
            style: theme.textTheme.titleMedium,
          ),
          Text(
            s.setOf(confirming.setIndex + 1, confirming.setCount),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          StrengthSetRow(
            exerciseKey: confirming.exercise.storageKey,
            setIndex: confirming.setIndex,
            label: strengthSetLabel(
              confirming.displayKg,
              confirming.displayReps,
            ),
            placeholder: !confirming.edited && !confirming.done,
            done: confirming.done,
            onEdit: () => _edit(form, confirming),
            onToggle: () => _toggle(form, confirming),
          ),
          if (_phase == _Phase.finished) ...[
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.pop(),
              child: Text(s.text('Done')),
            ),
          ],
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            s.text(_error!),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }

  String _clock(Duration remaining) {
    final seconds = remaining.isNegative ? 0 : remaining.inSeconds;
    final minutes = seconds ~/ 60;
    final rest = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$rest';
  }
}
