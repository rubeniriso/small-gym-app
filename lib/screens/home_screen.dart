import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/routine_kind.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/prescription_lines.dart';
import 'package:gym_app/widgets/session_actions.dart';
import 'package:gym_app/widgets/workout_pick.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    return DatabaseView(
      value: home,
      builder: (context, data) {
        final s = context.s;
        if (data.routineName == null) {
          return Center(child: Text(s.text('No current routine.')));
        }
        final theme = Theme.of(context);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(data.routineName!, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              s.longDate(data.day),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ..._today(context, data),
          ],
        );
      },
    );
  }

  List<Widget> _today(BuildContext context, HomeData data) {
    final today = data.today;
    final theme = Theme.of(context);
    final s = context.s;
    return switch (today) {
      TodayNone() => [Text(s.text('No current routine.'))],
      TodayRest() => [
        Text(s.text('Rest'), style: theme.textTheme.headlineMedium),
      ],
      TodayNoSession() => [Text(s.text('This plan has no session today.'))],
      TodayNeedsWorkout() => [
        Text(s.text('Choose a workout for today.')),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: () => context.push('/routines/${data.routineId}'),
            child: Text(
              data.kind == RoutineKind.dynamicDay
                  ? s.text('Open routine')
                  : data.kind == RoutineKind.customPattern
                  ? s.text('Edit pattern')
                  : s.text('Edit week'),
            ),
          ),
        ),
      ],
      TodayWorkout() => [
        Text(
          s.workoutName(today.workoutName),
          style: theme.textTheme.titleLarge,
        ),
        if (today.choices.length > 1 &&
            !today.logged &&
            data.routineId != null) ...[
          const SizedBox(height: 12),
          WorkoutPick(
            routineId: data.routineId!,
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
          onLog: () => context.push('/log'),
          onAutopilot: () => context.push('/autopilot'),
        ),
      ],
    };
  }
}
