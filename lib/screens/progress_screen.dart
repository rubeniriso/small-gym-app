import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';
import 'package:gym_app/widgets/progress_chart.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key, required this.routineId});

  final int routineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(routineProgressProvider(routineId));
    return DatabaseView(
      value: progress,
      builder: (context, rows) {
        if (rows.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                context.s.text('Add an exercise to a workout to see progress.'),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: rows.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final row = rows[index];
            final s = context.s;
            return Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: Text(
                  s.progressTitle(
                    exercise: row.exercise,
                    title: row.title,
                    targetReps: row.targetReps,
                  ),
                ),
                subtitle: Text(row.latestLabel ?? s.text('No sessions yet')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  final reps = row.targetReps;
                  final query = reps == null ? '' : '?reps=$reps';
                  context.push(
                    '/routines/$routineId/progress/${row.exercise.storageKey}$query',
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ExerciseProgressScreen extends ConsumerWidget {
  const ExerciseProgressScreen({
    super.key,
    required this.routineId,
    required this.exerciseKey,
    this.targetReps,
  });

  final int routineId;
  final String exerciseKey;
  final int? targetReps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(
      exerciseProgressProvider((
        routineId: routineId,
        exerciseKey: exerciseKey,
        targetReps: targetReps,
      )),
    );
    return DatabaseView(
      value: progress,
      builder: (context, data) =>
          _ProgressBody(progress: data, targetReps: targetReps),
    );
  }
}

class _ProgressBody extends StatefulWidget {
  const _ProgressBody({required this.progress, this.targetReps});

  final ExerciseProgress progress;
  final int? targetReps;

  @override
  State<_ProgressBody> createState() => _ProgressBodyState();
}

class _ProgressBodyState extends State<_ProgressBody> {
  var _series = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.s;
    final series = widget.progress.series;
    final selected = series[_series.clamp(0, series.length - 1)];
    final points = selected.points;
    final reps = widget.targetReps;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          reps == null
              ? s.exerciseName(widget.progress.exercise)
              : s.exerciseWithReps(widget.progress.exercise, reps),
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        if (series.length > 1) ...[
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: [
              for (var index = 0; index < series.length; index++)
                ButtonSegment(
                  value: index,
                  label: Text(s.seriesLabel(series[index].label)),
                ),
            ],
            selected: {_series},
            onSelectionChanged: (selection) {
              setState(() => _series = selection.first);
            },
          ),
          const SizedBox(height: 16),
        ] else
          Text(
            s.seriesLabel(selected.label),
            style: theme.textTheme.titleMedium,
          ),
        const SizedBox(height: 8),
        if (points.isEmpty)
          Text(
            s.text('No sessions logged yet.'),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else ...[
          ProgressChart(points: points, unit: selected.unit),
          const SizedBox(height: 16),
          for (final point in points.reversed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${s.longDate(point.day)} · ${_value(point.value, selected.unit)} ${selected.unit}',
              ),
            ),
        ],
      ],
    );
  }

  String _value(double value, String unit) {
    if (unit == 'min') {
      return value.round().toString();
    }
    return formatKg(value);
  }
}
