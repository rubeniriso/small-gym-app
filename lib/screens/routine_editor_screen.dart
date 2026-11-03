import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/routine_kind.dart';
import 'package:gym_app/domain/schedule.dart';
import 'package:gym_app/domain/sprint.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/screens/progress_screen.dart';
import 'package:gym_app/widgets/activity_calendar.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/plan_summary.dart';
import 'package:gym_app/widgets/prescription_lines.dart';
import 'package:gym_app/widgets/session_actions.dart';
import 'package:gym_app/widgets/duration_picker.dart';
import 'package:gym_app/widgets/gym_icons.dart';
import 'package:gym_app/widgets/increment_picker.dart';
import 'package:gym_app/widgets/workout_pick.dart';

class RoutineEditorScreen extends ConsumerStatefulWidget {
  const RoutineEditorScreen({super.key, required this.routineId});

  final int routineId;

  @override
  ConsumerState<RoutineEditorScreen> createState() =>
      _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  var _tab = 0;
  var _calendar = false;

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(routineDetailsProvider(widget.routineId));
    return DatabaseView(
      value: details,
      builder: (context, routine) {
        final theme = Theme.of(context);
        return SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            routine.name,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        IconButton(
                          tooltip: context.s.text('Share'),
                          onPressed: () => _export(routine),
                          icon: const Icon(Icons.ios_share),
                        ),
                        IconButton(
                          onPressed: routine.isCurrent
                              ? null
                              : () {
                                  ref.mutate(
                                    (repository) => repository
                                        .setCurrentRoutine(routine.id),
                                  );
                                },
                          style: IconButton.styleFrom(
                            disabledForegroundColor: theme.colorScheme.primary,
                          ),
                          icon: Icon(
                            routine.isCurrent ? Icons.star : Icons.star_border,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        key: const Key('change-type'),
                        onPressed: () => _changeType(routine),
                        child: Text(context.s.text('Change type')),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: switch (_tab) {
                  0 => _SummaryTab(routine: routine),
                  1 =>
                    _calendar
                        ? ActivityCalendar(routineId: routine.id)
                        : ProgressScreen(routineId: routine.id),
                  2 => _PlanTab(routine: routine),
                  _ => _WorkoutsTab(routine: routine),
                },
              ),
              if (_tab == 1)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SegmentedButton<bool>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: false,
                        label: Text(context.s.text('Charts')),
                      ),
                      ButtonSegment(
                        value: true,
                        label: Text(context.s.text('Calendar')),
                      ),
                    ],
                    selected: {_calendar},
                    onSelectionChanged: (selection) {
                      setState(() => _calendar = selection.first);
                    },
                  ),
                ),
              NavigationBar(
                selectedIndex: _tab,
                onDestinationSelected: (index) => setState(() => _tab = index),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.today_outlined),
                    selectedIcon: const Icon(Icons.today),
                    label: context.s.text('Summary'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.show_chart_outlined),
                    selectedIcon: const Icon(Icons.show_chart),
                    label: context.s.text('Progress'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.calendar_month_outlined),
                    selectedIcon: const Icon(Icons.calendar_month),
                    label: context.s.text('Plan'),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.fitness_center_outlined),
                    selectedIcon: const Icon(Icons.fitness_center),
                    label: context.s.text('Workouts'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeType(RoutineDetails routine) async {
    final picked = await showDialog<RoutineKind>(
      context: context,
      builder: (context) => _ChangeTypeDialog(initial: routine.kind),
    );
    if (picked == null || picked == routine.kind || !mounted) {
      return;
    }
    await ref.mutate(
      (repository) => repository.setRoutineKind(routine.id, picked),
    );
  }

  Future<void> _export(RoutineDetails routine) async {
    final repository = await ref.read(repositoryProvider.future);
    final json = await repository.exportRoutine(routine.id);
    await Clipboard.setData(ClipboardData(text: json));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.s.text('Template copied.'))));
  }
}

class _ChangeTypeDialog extends StatefulWidget {
  const _ChangeTypeDialog({required this.initial});

  final RoutineKind initial;

  @override
  State<_ChangeTypeDialog> createState() => _ChangeTypeDialogState();
}

class _ChangeTypeDialogState extends State<_ChangeTypeDialog> {
  late RoutineKind _kind;

  @override
  void initState() {
    super.initState();
    _kind = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return AlertDialog(
      title: Text(s.text('Change type')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final kind in RoutineKind.values)
            ListTile(
              key: Key('routine-type-${kind.name}'),
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: Icon(
                _kind == kind
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(s.routineKind(kind)),
              onTap: () => setState(() => _kind = kind),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.text('Cancel')),
        ),
        TextButton(
          key: const Key('change-type-save'),
          onPressed: () => Navigator.pop(context, _kind),
          child: Text(s.text('Save')),
        ),
      ],
    );
  }
}

class _SummaryTab extends ConsumerWidget {
  const _SummaryTab({required this.routine});

  final RoutineDetails routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(routineHomeProvider(routine.id));
    return DatabaseView(
      value: home,
      builder: (context, data) {
        final theme = Theme.of(context);
        final s = context.s;
        final today = data.today;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Text(
              s.longDate(data.day),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...switch (today) {
              TodayNone() || TodayNoSession() => [
                Text(s.text('This plan has no session today.')),
              ],
              TodayRest() => [
                Text(s.text('Rest'), style: theme.textTheme.headlineMedium),
              ],
              TodayNeedsWorkout() => [
                Text(s.text('Add a workout, then choose it for today.')),
              ],
              TodayWorkout() => [
                Text(
                  s.workoutName(today.workoutName),
                  style: theme.textTheme.titleLarge,
                ),
                if (today.choices.length > 1 && !today.logged) ...[
                  const SizedBox(height: 12),
                  WorkoutPick(
                    routineId: routine.id,
                    day: data.day,
                    workouts: today.choices,
                    selectedId: today.workoutId,
                  ),
                ],
                const SizedBox(height: 12),
                for (final exercise in today.exercises) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.exerciseName(exercise.exercise)),
                    subtitle: PrescriptionLines(exercise: exercise),
                  ),
                  const Divider(height: 1),
                ],
                const SizedBox(height: 24),
                SessionActions(
                  logged: today.logged,
                  autopilot: today.hasStrength,
                  onLog: () => context.push('/routines/${routine.id}/log'),
                  onAutopilot: () =>
                      context.push('/routines/${routine.id}/autopilot'),
                ),
              ],
            },
          ],
        );
      },
    );
  }
}

class _PlanTab extends ConsumerWidget {
  const _PlanTab({required this.routine});

  final RoutineDetails routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (routine.isDynamic) {
      return _DynamicPlan(routine: routine);
    }
    if (routine.isPattern) {
      return _PatternPlan(routine: routine);
    }
    final plan = ref.watch(planDaysProvider(routine.id));
    return DatabaseView(
      value: plan,
      builder: (context, days) {
        return ListView(
          key: const Key('plan-list'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            if (routine.isTemplate) ...[
              Text(context.s.weekOneStarts(routine.anchorMonday!)),
              const SizedBox(height: 12),
            ],
            PlanSummary(routineId: routine.id, days: days),
          ],
        );
      },
    );
  }
}

class _DynamicPlan extends ConsumerWidget {
  const _DynamicPlan({required this.routine});

  final RoutineDetails routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(routineHomeProvider(routine.id));
    return DatabaseView(
      value: home,
      builder: (context, data) {
        final today = data.today;
        final selected = today is TodayWorkout ? today.workoutId : null;
        final logged = today is TodayWorkout && today.logged;
        final theme = Theme.of(context);
        final s = context.s;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Text(
              s.text(
                'Choose any workout for today. The next one is only a suggestion.',
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            if (routine.workouts.isEmpty)
              Text(s.text('Add a workout in Workouts.'))
            else
              for (final workout in routine.workouts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(s.workoutName(workout.name)),
                  subtitle: workout.id == selected
                      ? Text(s.text('Today'))
                      : null,
                  trailing: logged || workout.id == selected
                      ? null
                      : TextButton(
                          onPressed: () {
                            ref.mutate(
                              (repository) => repository.pickWorkout(
                                routineId: routine.id,
                                day: data.day,
                                workoutId: workout.id,
                              ),
                            );
                          },
                          child: Text(s.text('Do today')),
                        ),
                ),
          ],
        );
      },
    );
  }
}

class _WorkoutsTab extends ConsumerWidget {
  const _WorkoutsTab({required this.routine});

  final RoutineDetails routine;

  List<Widget> _settings(BuildContext context, WidgetRef ref) {
    return [
      Row(
        children: [
          IconValueButton(
            icon: const StopwatchIcon(),
            value: formatDuration(routine.restSeconds),
            onPressed: () => _editRest(context, ref),
          ),
          const SizedBox(width: 16),
          IconValueButton(
            icon: const PlateUpIcon(),
            value: formatIncrement(routine.increment),
            onPressed: () => _editIncrement(context, ref),
          ),
        ],
      ),
    ];
  }

  Future<void> _editRest(BuildContext context, WidgetRef ref) async {
    final picked = await showDurationPicker(
      context,
      initialSeconds: routine.restSeconds,
      maxMinutes: restMaxMinutes,
    );
    final seconds = picked?.seconds;
    if (picked == null ||
        picked.cleared ||
        seconds == null ||
        !context.mounted) {
      return;
    }
    await ref.mutate(
      (repository) => repository.setRestSeconds(routine.id, seconds),
    );
  }

  Future<void> _editIncrement(BuildContext context, WidgetRef ref) async {
    final picked = await showIncrementPicker(
      context,
      initial: routine.increment,
    );
    final increment = picked?.increment;
    if (picked == null ||
        picked.cleared ||
        increment == null ||
        !context.mounted) {
      return;
    }
    await ref.mutate(
      (repository) => repository.setIncrement(routine.id, increment),
    );
  }

  List<Widget> _startingWeights(BuildContext context, ThemeData theme) {
    final s = context.s;
    return [
      Text(s.text('Starting weights'), style: theme.textTheme.titleSmall),
      const SizedBox(height: 8),
      for (final exercise in Exercise.strongLifts)
        if (routine.startWeightsKg.containsKey(exercise))
          Text(
            '${s.exerciseName(exercise)} ${formatKg(routine.startWeightsKg[exercise]!)} kg',
          ),
      const SizedBox(height: 8),
    ];
  }

  Future<void> _createWorkout(BuildContext context, WidgetRef ref) async {
    final id = await ref.mutate(
      (repository) => repository.createWorkout(
        routineId: routine.id,
        name: context.s.defaultWorkoutName(routine.workouts.length),
      ),
    );
    if (!context.mounted) {
      return;
    }
    context.push('/routines/${routine.id}/workouts/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (routine.isDynamic) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          ..._settings(context, ref),
          Text(
            context.s.text(
              'This routine is dynamic. Pick the workout each day.',
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          if (routine.isTemplate) ..._startingWeights(context, theme),
          for (final workout in routine.workouts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.s.workoutName(workout.name)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                '/routines/${routine.id}/workouts/${workout.id}',
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _createWorkout(context, ref),
              child: Text(context.s.text('New workout')),
            ),
          ),
        ],
      );
    }
    if (routine.isPattern) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          ..._settings(context, ref),
          Text(
            context.s.text('Assign these workouts to numbered days on Plan.'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          for (final workout in routine.workouts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.s.workoutName(workout.name)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                '/routines/${routine.id}/workouts/${workout.id}',
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _createWorkout(context, ref),
              child: Text(context.s.text('New workout')),
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        ..._settings(context, ref),
        if (routine.isTemplate) ...[
          ..._startingWeights(context, theme),
          for (final workout in routine.workouts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.s.workoutName(workout.name)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                '/routines/${routine.id}/workouts/${workout.id}',
              ),
            ),
          const SizedBox(height: 8),
        ],
        Text(context.s.text('Week'), style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final day in routine.days) ...[
          _DayEditor(routine: routine, day: day),
          const Divider(height: 24),
        ],
      ],
    );
  }
}

class _DayEditor extends ConsumerWidget {
  const _DayEditor({required this.routine, required this.day});

  final RoutineDetails routine;
  final WeekdayRow day;

  bool get _slotDay =>
      routine.isTemplate && isTemplateTrainingWeekday(day.weekday);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = context.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.weekday(day.weekday), style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          key: Key('day-${day.weekday}'),
          showSelectedIcon: false,
          segments: [
            ButtonSegment(value: true, label: Text(s.text('Rest'))),
            ButtonSegment(value: false, label: Text(s.text('Workout'))),
          ],
          selected: {day.isRest},
          onSelectionChanged: (selection) {
            _setMode(context, ref, selection.first);
          },
        ),
        if (!day.isRest && _slotDay)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              s.text('12-week plan'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        if (!day.isRest && !_slotDay && day.workoutId != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(s.workoutName(day.workoutName ?? 'Workout')),
                ),
                TextButton(
                  onPressed: () => context.push(
                    '/routines/${routine.id}/workouts/${day.workoutId}',
                  ),
                  child: Text(s.text('Edit')),
                ),
                TextButton(
                  onPressed: () => _chooseWorkout(context, ref),
                  child: Text(s.text('Change')),
                ),
              ],
            ),
          ),
        if (!day.isRest && !_slotDay && day.workoutId == null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _chooseWorkout(context, ref),
              child: Text(s.text('Choose a workout')),
            ),
          ),
      ],
    );
  }

  Future<void> _setMode(
    BuildContext context,
    WidgetRef ref,
    bool isRest,
  ) async {
    if (isRest) {
      await ref.mutate(
        (repository) => repository.setWeekday(
          routineId: routine.id,
          weekday: day.weekday,
          isRest: true,
        ),
      );
      return;
    }
    if (_slotDay) {
      await ref.mutate(
        (repository) => repository.setWeekday(
          routineId: routine.id,
          weekday: day.weekday,
          isRest: false,
        ),
      );
      return;
    }
    if (day.workoutId != null) {
      await ref.mutate(
        (repository) => repository.setWeekday(
          routineId: routine.id,
          weekday: day.weekday,
          isRest: false,
          workoutId: day.workoutId,
        ),
      );
      return;
    }
    await _chooseWorkout(context, ref);
  }

  Future<void> _chooseWorkout(BuildContext context, WidgetRef ref) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.s.text('New workout')),
                onTap: () => Navigator.pop(context, -1),
              ),
              for (final workout in routine.workouts)
                ListTile(
                  title: Text(context.s.workoutName(workout.name)),
                  onTap: () => Navigator.pop(context, workout.id),
                ),
            ],
          ),
        );
      },
    );
    if (selected == null || !context.mounted) {
      return;
    }
    if (selected == -1) {
      final id = await ref.mutate(
        (repository) => repository.createWorkout(
          routineId: routine.id,
          name: context.s.defaultWorkoutName(routine.workouts.length),
          linkWeekday: day.weekday,
        ),
      );
      if (!context.mounted) {
        return;
      }
      context.push('/routines/${routine.id}/workouts/$id');
      return;
    }
    await ref.mutate(
      (repository) => repository.setWeekday(
        routineId: routine.id,
        weekday: day.weekday,
        isRest: false,
        workoutId: selected,
      ),
    );
  }
}

class _PatternPlan extends ConsumerWidget {
  const _PatternPlan({required this.routine});

  final RoutineDetails routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(planDaysProvider(routine.id));
    final theme = Theme.of(context);
    final s = context.s;
    return DatabaseView(
      value: plan,
      builder: (context, days) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Text(s.text('Pattern'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              s.text(
                'Numbered days repeat from the start date. After the last day, the sequence starts again.',
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _pickStart(context, ref),
                child: Text(
                  routine.patternStart == null
                      ? s.text('Choose a start date')
                      : s.startsOn(routine.patternStart!),
                ),
              ),
            ),
            if (routine.pattern.isEmpty)
              Text(s.text('Add a day to build the sequence.'))
            else
              for (final day in routine.pattern) ...[
                _PatternDayEditor(routine: routine, day: day),
                const Divider(height: 24),
              ],
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  ref.mutate(
                    (repository) => repository.addPatternDay(routine.id),
                  );
                },
                child: Text(s.text('Add day')),
              ),
            ),
            if (routine.pattern.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(s.text('Calendar'), style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              PlanSummary(routineId: routine.id, days: days),
            ],
          ],
        );
      },
    );
  }

  Future<void> _pickStart(BuildContext context, WidgetRef ref) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: routine.patternStart ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !context.mounted) {
      return;
    }
    await ref.mutate(
      (repository) =>
          repository.setPatternStart(routineId: routine.id, start: picked),
    );
  }
}

class _PatternDayEditor extends ConsumerWidget {
  const _PatternDayEditor({required this.routine, required this.day});

  final RoutineDetails routine;
  final PatternDayRow day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = context.s;
    final title = s.patternDay(
      day.position,
      rest: day.isRest,
      workoutName: day.workoutName,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          key: Key('pattern-day-${day.position}'),
          showSelectedIcon: false,
          segments: [
            ButtonSegment(value: true, label: Text(s.text('Rest'))),
            ButtonSegment(value: false, label: Text(s.text('Workout'))),
          ],
          selected: {day.isRest},
          onSelectionChanged: (selection) {
            _setMode(context, ref, selection.first);
          },
        ),
        if (!day.isRest && day.workoutId != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(s.workoutName(day.workoutName ?? 'Workout')),
                ),
                TextButton(
                  onPressed: () => context.push(
                    '/routines/${routine.id}/workouts/${day.workoutId}',
                  ),
                  child: Text(s.text('Edit')),
                ),
                TextButton(
                  onPressed: () => _chooseWorkout(context, ref),
                  child: Text(s.text('Change')),
                ),
              ],
            ),
          ),
        if (!day.isRest && day.workoutId == null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _chooseWorkout(context, ref),
              child: Text(s.text('Choose a workout')),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              ref.mutate(
                (repository) => repository.removePatternDay(
                  routineId: routine.id,
                  position: day.position,
                ),
              );
            },
            child: Text(s.text('Remove')),
          ),
        ),
      ],
    );
  }

  Future<void> _setMode(
    BuildContext context,
    WidgetRef ref,
    bool isRest,
  ) async {
    if (isRest) {
      await ref.mutate(
        (repository) => repository.setPatternDay(
          routineId: routine.id,
          position: day.position,
          isRest: true,
        ),
      );
      return;
    }
    if (day.workoutId != null) {
      await ref.mutate(
        (repository) => repository.setPatternDay(
          routineId: routine.id,
          position: day.position,
          isRest: false,
          workoutId: day.workoutId,
        ),
      );
      return;
    }
    await _chooseWorkout(context, ref);
  }

  Future<void> _chooseWorkout(BuildContext context, WidgetRef ref) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.s.text('New workout')),
                onTap: () => Navigator.pop(context, -1),
              ),
              for (final workout in routine.workouts)
                ListTile(
                  title: Text(context.s.workoutName(workout.name)),
                  onTap: () => Navigator.pop(context, workout.id),
                ),
            ],
          ),
        );
      },
    );
    if (selected == null || !context.mounted) {
      return;
    }
    if (selected == -1) {
      final id = await ref.mutate(
        (repository) => repository.createWorkout(
          routineId: routine.id,
          name: context.s.defaultWorkoutName(routine.workouts.length),
          linkPatternPosition: day.position,
        ),
      );
      if (!context.mounted) {
        return;
      }
      context.push('/routines/${routine.id}/workouts/$id');
      return;
    }
    await ref.mutate(
      (repository) => repository.setPatternDay(
        routineId: routine.id,
        position: day.position,
        isRest: false,
        workoutId: selected,
      ),
    );
  }
}
