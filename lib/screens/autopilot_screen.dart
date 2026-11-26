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
    final scheme = theme.colorScheme;
    final current = _steps[_index.clamp(0, _steps.length - 1)];
    final done = _steps.where((step) => step.done).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  s.workoutName(form.workoutName),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                '$done/${_steps.length}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            children: [
              for (var index = 0; index < _steps.length; index++) ...[
                if (index > 0) const SizedBox(width: 3),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _steps[index].done
                          ? scheme.primary
                          : index == _index && _phase == _Phase.perform
                          ? scheme.primary.withValues(alpha: 0.4)
                          : scheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: [
              if (_phase == _Phase.perform)
                ..._perform(current)
              else
                ..._confirm(form),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(s.text(_error!), style: TextStyle(color: scheme.error)),
              ],
            ],
          ),
        ),
        if (_phase == _Phase.perform || _phase == _Phase.finished)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: _phase == _Phase.perform
                  ? FilledButton(onPressed: _next, child: Text(s.text('Next')))
                  : FilledButton(
                      onPressed: () => context.pop(),
                      child: Text(s.text('Done')),
                    ),
            ),
          ),
      ],
    );
  }

  List<Widget> _perform(_Step step) {
    final theme = Theme.of(context);
    final s = context.s;
    return [
      const SizedBox(height: 40),
      Text(
        s.exerciseName(step.exercise),
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineMedium,
      ),
      const SizedBox(height: 8),
      Text(
        s.setOf(step.setIndex + 1, step.setCount),
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      const SizedBox(height: 32),
      Text(
        strengthSetLabel(step.placeholderKg, step.placeholderReps),
        textAlign: TextAlign.center,
        style: theme.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w500,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    ];
  }

  List<Widget> _confirm(LogFormData form) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = context.s;
    final confirming = _steps[_index.clamp(0, _steps.length - 1)];
    final upcoming = _phase == _Phase.rest && _index < _steps.length - 1
        ? _steps[_index + 1]
        : null;
    final remaining = _budget - _elapsed;
    return [
      if (_phase == _Phase.rest) ...[
        Text(
          s.text('Rest'),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.primary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: _budget.inMilliseconds == 0
                      ? 0
                      : (remaining.inMilliseconds / _budget.inMilliseconds)
                            .clamp(0.0, 1.0),
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _clock(remaining),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      s.restOf(_clock(_budget)),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            for (final extra in const [5, 10, 30]) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _addRest(extra),
                  child: Text('+$extra'),
                ),
              ),
              if (extra != 30) const SizedBox(width: 10),
            ],
          ],
        ),
        const SizedBox(height: 28),
      ] else ...[
        Text(
          s.text('Last set'),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
      ],
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                s.exerciseName(confirming.exercise),
                style: theme.textTheme.titleSmall,
              ),
            ),
            Text(
              s.setOf(confirming.setIndex + 1, confirming.setCount),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      StrengthSetRow(
        exerciseKey: confirming.exercise.storageKey,
        setIndex: confirming.setIndex,
        label: strengthSetLabel(confirming.displayKg, confirming.displayReps),
        placeholder: !confirming.edited && !confirming.done,
        done: confirming.done,
        onEdit: () => _edit(form, confirming),
        onToggle: () => _toggle(form, confirming),
      ),
      if (_phase == _Phase.rest) ...[
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: upcoming == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.text('Up next'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            s.upNext(
                              s.exerciseName(upcoming.exercise),
                              upcoming.setIndex + 1,
                              strengthSetLabel(
                                upcoming.placeholderKg,
                                upcoming.placeholderReps,
                              ),
                            ),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            FilledButton.tonal(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
              onPressed: _skipRest,
              child: Text(s.text('Skip')),
            ),
          ],
        ),
      ],
    ];
  }

  String _clock(Duration remaining) {
    final seconds = remaining.isNegative ? 0 : remaining.inSeconds;
    final minutes = seconds ~/ 60;
    final rest = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$rest';
  }
}
