import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/prescription_lines.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    return DatabaseView(
      value: home,
      builder: (context, data) {
        if (data.routineName == null) {
          return const Center(child: Text('No current routine.'));
        }
        final theme = Theme.of(context);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(data.routineName!, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              formatLongDate(data.day),
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
    return switch (today) {
      TodayNone() => const [Text('No current routine.')],
      TodayRest() => [Text('Rest', style: theme.textTheme.headlineMedium)],
      TodayNoSession() => const [Text('This plan has no session today.')],
      TodayNeedsWorkout() => [
        const Text('Choose a workout for today.'),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: () => context.push('/routines/${data.routineId}'),
            child: const Text('Edit week'),
          ),
        ),
      ],
      TodayWorkout() => [
        Text(today.workoutName, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final exercise in today.exercises) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(exercise.exercise.label),
            subtitle: PrescriptionLines(exercise: exercise),
          ),
          const Divider(height: 1),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.push('/log'),
          child: Text(today.logged ? 'Edit log' : 'Log session'),
        ),
      ],
    };
  }
}
