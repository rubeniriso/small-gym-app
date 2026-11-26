import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/screens/sprint_timer_screen.dart';
import 'package:gym_app/widgets/duration_picker.dart';
import 'package:gym_app/widgets/exercise_picker.dart';
import 'package:gym_app/widgets/strength_set_row.dart';
import 'package:gym_app/widgets/ui.dart';

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
  final _sets = <Exercise, List<_SetDraft>>{};
  final _speeds = <Exercise, TextEditingController>{};
  final _durations = <Exercise, int>{};
  final _completed = <Exercise, List<LoggedInterval>>{};
  final _swapped = <Exercise, Exercise>{};

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
    final substitute = exercise.substitute;
    if (substitute != null) {
      _swapped[exercise.exercise] = substitute;
    }
    switch (exercise.exercise.kind) {
      case ExerciseKind.strength:
        _sets[exercise.exercise] = [
          for (final set in exercise.strengthSets) _SetDraft.fromSeed(set),
        ];
      case ExerciseKind.jogging:
        final speed = exercise.speedKmh;
        _speeds[exercise.exercise] = TextEditingController(
          text: speed == null ? '' : formatKg(speed),
        );
        _durations[exercise.exercise] = exercise.durationSeconds ?? 0;
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
    for (final controller in _speeds.values) {
      controller.dispose();
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
      if (exercise.exercise.kind == ExerciseKind.strength) {
        continue;
      }
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
        (repository) => repository.saveLifts(
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
        _error = context.s.errorMessage(error);
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
      return Center(child: Text(context.s.todayMessage(_unavailable)));
    }
    final theme = Theme.of(context);
    final s = context.s;
    final needsSave = form.exercises.any(
      (exercise) => exercise.exercise.kind != ExerciseKind.strength,
    );
    final hasStrength = form.exercises.any(
      (exercise) => exercise.exercise.kind == ExerciseKind.strength,
    );
    final drafts = [for (final sets in _sets.values) ...sets];
    final done = drafts.where((draft) => draft.done).length;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: PageHeading(
                        eyebrow: s.longDate(form.day),
                        title: s.workoutName(form.workoutName),
                      ),
                    ),
                    if (hasStrength) ...[
                      const SizedBox(width: 12),
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          textStyle: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          final id = widget.routineId;
                          context.push(
                            id == null
                                ? '/autopilot'
                                : '/routines/$id/autopilot',
                          );
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: Text(s.text('Autopilot')),
                      ),
                    ],
                  ],
                ),
                if (drafts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: done / drafts.length,
                            minHeight: 6,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        s.setsDone(done, drafts.length),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                for (final exercise in form.exercises) ...[
                  _ExerciseLogCard(
                    title: s.exerciseName(_currentExercise(exercise)),
                    caption:
                        !_swapped.containsKey(exercise.exercise) &&
                            exercise.previousKg != null &&
                            exercise.previousReps != null
                        ? s.lastTime(
                            exercise.previousKg!,
                            exercise.previousReps!,
                          )
                        : null,
                    complete: _complete(exercise),
                    onSwap: exercise.exercise.kind == ExerciseKind.strength
                        ? () => _changeExercise(form, exercise)
                        : null,
                    children: _fields(form, exercise),
                  ),
                  const SizedBox(height: 12),
                ],
                if (hasStrength)
                  Text(
                    s.text('Tap a set to mark it done. Long-press to edit it.'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    s.text(_error!),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (needsSave)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(
                    form.updating ? s.text('Update session') : s.text('Save'),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _complete(LogExerciseSeed exercise) {
    return switch (exercise.exercise.kind) {
      ExerciseKind.strength =>
        (_sets[exercise.exercise] ?? const []).isNotEmpty &&
            _sets[exercise.exercise]!.every((draft) => draft.done),
      ExerciseKind.sprinting => _completed[exercise.exercise] != null,
      ExerciseKind.jogging => false,
    };
  }

  Exercise _currentExercise(LogExerciseSeed exercise) {
    return _swapped[exercise.exercise] ?? exercise.exercise;
  }

  Future<void> _changeExercise(LogFormData form, LogExerciseSeed seed) async {
    final taken = {
      for (final exercise in form.exercises) _currentExercise(exercise),
    };
    taken.remove(_currentExercise(seed));
    final options = [
      for (final exercise in Exercise.catalog)
        if (exercise.kind == seed.exercise.kind && !taken.contains(exercise))
          exercise,
    ];
    final picked = await showExercisePicker(
      context,
      options,
      title: context.s.exerciseName(_currentExercise(seed)),
    );
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      if (picked == seed.exercise) {
        _swapped.remove(seed.exercise);
      } else {
        _swapped[seed.exercise] = picked;
      }
      _error = null;
    });
  }

  Future<void> _editSet(
    LogFormData form,
    LogExerciseSeed seed,
    int index,
  ) async {
    final draft = _sets[seed.exercise]![index];
    final edited = await editStrengthSet(
      context,
      weightKg: draft.displayKg,
      reps: draft.displayReps,
    );
    if (!mounted || edited == null) {
      return;
    }
    setState(() {
      draft.weight = edited.weightKg;
      draft.reps = edited.reps;
      draft.edited = true;
      _error = null;
    });
    if (draft.done) {
      await _saveSet(form, seed, index);
    }
  }

  Future<void> _toggleSet(
    LogFormData form,
    LogExerciseSeed seed,
    int index,
  ) async {
    final draft = _sets[seed.exercise]![index];
    if (draft.done) {
      try {
        await ref.mutate(
          (repository) => repository.clearStrengthSet(
            routineId: form.routineId,
            loggedOn: form.day,
            exercise: _currentExercise(seed),
            setIndex: index,
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
        draft.done = false;
        _error = null;
      });
      return;
    }
    await _saveSet(form, seed, index);
  }

  Future<void> _saveSet(
    LogFormData form,
    LogExerciseSeed seed,
    int index,
  ) async {
    final draft = _sets[seed.exercise]![index];
    try {
      await ref.mutate(
        (repository) => repository.saveStrengthSet(
          routineId: form.routineId,
          loggedOn: form.day,
          workoutId: form.workoutId,
          trainingSlotId: form.trainingSlotId,
          exercise: _currentExercise(seed),
          targetReps: seed.targetReps,
          setIndex: index,
          weightKg: draft.displayKg,
          reps: draft.displayReps,
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
      draft.done = true;
      draft.weight ??= draft.placeholderKg;
      draft.reps ??= draft.placeholderReps;
      _error = null;
    });
  }

  LoggedLift? _readLift(LogExerciseSeed exercise) {
    switch (exercise.exercise.kind) {
      case ExerciseKind.strength:
        return null;
      case ExerciseKind.jogging:
        final duration = _durations[exercise.exercise] ?? 0;
        final speed = tryParseKg(_speeds[exercise.exercise]!.text);
        if (duration <= 0) {
          setState(() => _error = 'Enter a duration.');
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
          targetReps: exercise.targetReps,
          speedKmh: speed,
          durationSeconds: duration,
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
          targetReps: exercise.targetReps,
          intervals: intervals,
        );
    }
  }

  List<Widget> _fields(LogFormData form, LogExerciseSeed exercise) {
    final s = context.s;
    switch (exercise.exercise.kind) {
      case ExerciseKind.strength:
        final drafts = _sets[exercise.exercise] ?? const <_SetDraft>[];
        return [
          SetPillGrid(
            children: [
              for (var index = 0; index < drafts.length; index++)
                SetPill(
                  key: Key('set-${exercise.exercise.storageKey}-$index'),
                  setIndex: index,
                  kg: drafts[index].displayKg,
                  reps: drafts[index].displayReps,
                  targetReps: exercise.targetReps,
                  placeholder: !drafts[index].edited && !drafts[index].done,
                  done: drafts[index].done,
                  onEdit: () => _editSet(form, exercise, index),
                  onToggle: () => _toggleSet(form, exercise, index),
                ),
            ],
          ),
        ];
      case ExerciseKind.jogging:
        return [
          DurationField(
            label: s.text('Duration'),
            seconds: (_durations[exercise.exercise] ?? 0) == 0
                ? null
                : _durations[exercise.exercise],
            maxMinutes: jogMaxMinutes,
            onChanged: (seconds) {
              setState(() => _durations[exercise.exercise] = seconds ?? 0);
            },
          ),
          const SizedBox(height: 8),
          _numberField(
            controller: _speeds[exercise.exercise]!,
            label: s.text('Speed (km/h)'),
            decimal: true,
          ),
          const SizedBox(height: 8),
        ];
      case ExerciseKind.sprinting:
        final done = _completed[exercise.exercise] != null;
        return [
          if (exercise.plan.isEmpty)
            Text(
              s.text('Add sprint intervals in the workout.'),
              textAlign: TextAlign.center,
            )
          else
            for (var index = 0; index < exercise.plan.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  s.sprintLine(exercise.plan[index], index),
                  textAlign: TextAlign.center,
                ),
              ),
          if (done)
            Text(s.text('Sprint complete.'), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: exercise.plan.isEmpty
                ? const SizedBox.shrink()
                : FilledButton(
                    onPressed: () => _openTimer(exercise),
                    child: Text(done ? s.text('Run again') : s.text('Start')),
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

class _SetDraft {
  _SetDraft.fromSeed(StrengthSet set)
    : placeholderKg = set.placeholderKg,
      placeholderReps = set.placeholderReps,
      weight = set.loggedKg,
      reps = set.loggedReps,
      done = set.done,
      edited = set.done;

  final double placeholderKg;
  final int placeholderReps;
  double? weight;
  int? reps;
  bool done;
  bool edited;

  double get displayKg => weight ?? placeholderKg;
  int get displayReps => reps ?? placeholderReps;
}

class _ExerciseLogCard extends StatelessWidget {
  const _ExerciseLogCard({
    required this.title,
    required this.caption,
    required this.complete,
    required this.onSwap,
    required this.children,
  });

  final String title;
  final String? caption;
  final bool complete;
  final VoidCallback? onSwap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      if (caption != null)
                        Text(
                          caption!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (complete)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.check_circle,
                      color: scheme.primary,
                      semanticLabel: context.s.text('Done'),
                    ),
                  ),
                if (onSwap != null)
                  IconButton(
                    tooltip: context.s.text('Swap exercise'),
                    onPressed: onSwap,
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.surfaceContainerHigh,
                    ),
                    icon: const Icon(Icons.swap_horiz, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}
