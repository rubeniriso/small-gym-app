import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/prescription_lines.dart';
import 'package:gym_app/widgets/session_actions.dart';
import 'package:gym_app/widgets/workout_pick.dart';

class DayScreen extends ConsumerWidget {
  const DayScreen({super.key, required this.routineId, required this.iso});

  final int routineId;
  final String iso;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(dayProvider((routineId: routineId, iso: iso)));
    return DatabaseView(
      value: day,
      builder: (context, today) {
        final date = parseIsoDate(iso);
        final clock = dateOnly(ref.watch(clockProvider)());
        final isToday = dateOnly(date) == clock;
        final theme = Theme.of(context);
        final s = context.s;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              s.longDate(date),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ..._body(context, today, isToday),
          ],
        );
      },
    );
  }

  List<Widget> _body(BuildContext context, TodayView today, bool isToday) {
    final theme = Theme.of(context);
    final s = context.s;
    return switch (today) {
      TodayNone() ||
      TodayNoSession() => [Text(s.text('This plan has no session today.'))],
      TodayRest() => [
        Text(s.text('Rest'), style: theme.textTheme.headlineMedium),
      ],
      TodayNeedsWorkout() => [Text(s.text('Choose a workout.'))],
      TodayWorkout() => [
        Text(
          s.workoutName(today.workoutName),
          style: theme.textTheme.titleLarge,
        ),
        if (isToday && today.choices.length > 1 && !today.logged) ...[
          const SizedBox(height: 12),
          WorkoutPick(
            routineId: routineId,
            day: parseIsoDate(iso),
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
        if (isToday) ...[
          const SizedBox(height: 24),
          SessionActions(
            logged: today.logged,
            autopilot: today.hasStrength,
            onLog: () => context.push('/routines/$routineId/log'),
            onAutopilot: () => context.push('/routines/$routineId/autopilot'),
          ),
        ],
      ],
    };
  }
}
