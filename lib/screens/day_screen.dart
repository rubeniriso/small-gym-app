import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/prescription_lines.dart';

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
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              formatLongDate(date),
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
    return switch (today) {
      TodayNone() ||
      TodayNoSession() => const [Text('This plan has no session today.')],
      TodayRest() => [Text('Rest', style: theme.textTheme.headlineMedium)],
      TodayNeedsWorkout() => const [Text('Choose a workout.')],
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
        if (isToday) ...[
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.push('/routines/$routineId/log'),
            child: Text(today.logged ? 'Edit log' : 'Log session'),
          ),
        ],
      ],
    };
  }
}
