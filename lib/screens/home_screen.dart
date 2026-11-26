import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/routine_kind.dart';
import 'package:gym_app/domain/schedule.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/prescription_lines.dart';
import 'package:gym_app/widgets/session_actions.dart';
import 'package:gym_app/widgets/ui.dart';
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
        final today = data.today;
        final week = _week(ref, data);
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  PageHeading(
                    eyebrow: s.longDate(data.day),
                    title: data.routineName!,
                  ),
                  if (data.routineId != null) ...[
                    const SizedBox(height: 20),
                    WeekStrip(routineId: data.routineId!),
                  ],
                  const SizedBox(height: 20),
                  ..._today(context, data, week),
                ],
              ),
            ),
            if (today is TodayWorkout)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SessionActions(
                    logged: today.logged,
                    autopilot: today.hasStrength,
                    onLog: () => context.push('/log'),
                    onAutopilot: () => context.push('/autopilot'),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  int? _week(WidgetRef ref, HomeData data) {
    final id = data.routineId;
    if (id == null) {
      return null;
    }
    final anchor = ref.watch(routineDetailsProvider(id)).value?.anchorMonday;
    return anchor == null ? null : templateWeekOf(anchor, data.day);
  }

  List<Widget> _today(BuildContext context, HomeData data, int? week) {
    final today = data.today;
    final theme = Theme.of(context);
    final s = context.s;
    return switch (today) {
      TodayNone() => [_Message(s.text('No current routine.'))],
      TodayRest() => [
        HeroCard(
          child: Row(
            children: [
              const Icon(Icons.bedtime_outlined, size: 28),
              const SizedBox(width: 14),
              Text(s.text('Rest'), style: theme.textTheme.headlineSmall),
            ],
          ),
        ),
      ],
      TodayNoSession() => [_Message(s.text('This plan has no session today.'))],
      TodayNeedsWorkout() => [
        HeroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.text('Choose a workout for today.'),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.push('/routines/${data.routineId}'),
                child: Text(
                  data.kind == RoutineKind.dynamicDay
                      ? s.text('Open routine')
                      : data.kind == RoutineKind.customPattern
                      ? s.text('Edit pattern')
                      : s.text('Edit week'),
                ),
              ),
            ],
          ),
        ),
      ],
      TodayWorkout() => [
        _TodayCard(data: data, today: today, week: week),
        const SizedBox(height: 16),
        for (final exercise in today.exercises) ...[
          ExerciseCard(
            kind: exercise.exercise.kind,
            title: s.exerciseName(exercise.exercise),
            subtitle: PrescriptionLines(exercise: exercise),
            trailing: _ProgressPill(exercise: exercise),
          ),
          const SizedBox(height: 10),
        ],
      ],
    };
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.data,
    required this.today,
    required this.week,
  });

  final HomeData data;
  final TodayWorkout today;
  final int? week;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sets = today.exercises
        .where((exercise) => exercise.exercise.kind == ExerciseKind.strength)
        .fold<int>(0, (total, exercise) => total + exercise.sets);
    final label = week == null
        ? s.text('Today')
        : '${s.text('Today')} · ${s.weekNumber(week!)}';
    return HeroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.workoutName(today.workoutName),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              if (today.logged)
                InfoPill(s.text('Logged'), tone: PillTone.primary),
            ],
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
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoPill(
                s.exerciseCount(today.exercises.length),
                tone: PillTone.onHero,
              ),
              if (sets > 0) InfoPill(s.setCount(sets), tone: PillTone.onHero),
            ],
          ),
        ],
      ),
    );
  }
}

/// How today's weight compares with the previous session of the lift.
class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.exercise});

  final PrescribedExercise exercise;

  @override
  Widget build(BuildContext context) {
    final now = exercise.weightKg;
    final before = exercise.previousKg;
    if (now == null || before == null) {
      return const SizedBox.shrink();
    }
    final change = roundKg(now - before);
    if (change == 0) {
      return InfoPill(context.s.text('Same'));
    }
    if (change > 0) {
      return InfoPill('+${formatKg(change)} kg', tone: PillTone.positive);
    }
    return InfoPill('−${formatKg(-change)} kg');
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(padding: const EdgeInsets.all(20), child: Text(text)),
    );
  }
}
