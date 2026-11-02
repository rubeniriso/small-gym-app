import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/schedule.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/screens/progress_screen.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/plan_summary.dart';

class RoutineEditorScreen extends ConsumerStatefulWidget {
  const RoutineEditorScreen({super.key, required this.routineId});

  final int routineId;

  @override
  ConsumerState<RoutineEditorScreen> createState() =>
      _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  var _tab = 1;

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(routine.name, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    if (routine.isCurrent)
                      Text(
                        'Current',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      )
                    else
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            ref.mutate(
                              (repository) =>
                                  repository.setCurrentRoutine(routine.id),
                            );
                          },
                          child: const Text('Set as current'),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: switch (_tab) {
                  0 => ProgressScreen(routineId: routine.id),
                  1 => _PlanTab(routine: routine),
                  _ => _WorkoutsTab(routine: routine),
                },
              ),
              NavigationBar(
                selectedIndex: _tab,
                onDestinationSelected: (index) => setState(() => _tab = index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.show_chart_outlined),
                    selectedIcon: Icon(Icons.show_chart),
                    label: 'Progress',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    selectedIcon: Icon(Icons.calendar_month),
                    label: 'Plan',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.fitness_center_outlined),
                    selectedIcon: Icon(Icons.fitness_center),
                    label: 'Workouts',
                  ),
                ],
              ),
            ],
          ),
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
    final plan = ref.watch(planDaysProvider(routine.id));
    return DatabaseView(
      value: plan,
      builder: (context, days) {
        return ListView(
          key: const Key('plan-list'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            if (routine.isTemplate) ...[
              Text('Week 1 starts ${formatLongDate(routine.anchorMonday!)}'),
              const SizedBox(height: 12),
            ],
            PlanSummary(routineId: routine.id, days: days),
          ],
        );
      },
    );
  }
}

class _WorkoutsTab extends StatelessWidget {
  const _WorkoutsTab({required this.routine});

  final RoutineDetails routine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        if (routine.isTemplate) ...[
          Text('Starting weights', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final exercise in Exercise.strongLifts)
            if (routine.startWeightsKg.containsKey(exercise))
              Text(
                '${exercise.label} ${formatKg(routine.startWeightsKg[exercise]!)} kg',
              ),
          const SizedBox(height: 8),
          for (final workout in routine.workouts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(workout.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                '/routines/${routine.id}/workouts/${workout.id}',
              ),
            ),
          const SizedBox(height: 8),
        ],
        Text('Week', style: theme.textTheme.titleMedium),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(weekdayLabel(day.weekday), style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          key: Key('day-${day.weekday}'),
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: true, label: Text('Rest')),
            ButtonSegment(value: false, label: Text('Workout')),
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
              '12-week plan',
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
                Expanded(child: Text(day.workoutName ?? 'Workout')),
                TextButton(
                  onPressed: () => context.push(
                    '/routines/${routine.id}/workouts/${day.workoutId}',
                  ),
                  child: const Text('Edit'),
                ),
                TextButton(
                  onPressed: () => _chooseWorkout(context, ref),
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
        if (!day.isRest && !_slotDay && day.workoutId == null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _chooseWorkout(context, ref),
              child: const Text('Choose a workout'),
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
                title: const Text('New workout'),
                onTap: () => Navigator.pop(context, -1),
              ),
              for (final workout in routine.workouts)
                ListTile(
                  title: Text(workout.name),
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
          name: routine.workouts.isEmpty
              ? 'Workout'
              : 'Workout ${routine.workouts.length + 1}',
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
