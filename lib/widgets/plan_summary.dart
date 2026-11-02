import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/models.dart';

const _weekdayInitials = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

class PlanSummary extends StatelessWidget {
  const PlanSummary({super.key, required this.routineId, required this.days});

  final int routineId;
  final List<PlanDay> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = days.where((day) => day.isToday).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _caption(today),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        if (days.length <= 7)
          for (final day in days) _WeekRow(routineId: routineId, day: day)
        else ...[
          if (today != null) ...[
            Text('This week', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            for (final day in _weekOf(days, today))
              _WeekRow(routineId: routineId, day: day),
            const SizedBox(height: 12),
          ],
          const _GridHeader(),
          for (var index = 0; index < days.length; index += 7)
            _GridWeek(
              routineId: routineId,
              week: index ~/ 7 + 1,
              days: days.sublist(index, index + 7),
            ),
        ],
      ],
    );
  }

  String _caption(PlanDay? today) {
    if (today == null) {
      return 'This plan has no session today.';
    }
    if (today.canLog) {
      final name = today.workoutName ?? 'Workout';
      return 'Today is $name. Tap a day to see the workout.';
    }
    if (today.isRest) {
      return 'Today is rest. Tap a day to see the workout.';
    }
    if (today.needsWorkout) {
      return 'Choose a workout for today. Tap a day to see the workout.';
    }
    return 'This plan has no session today.';
  }
}

List<PlanDay> _weekOf(List<PlanDay> days, PlanDay today) {
  final index = days.indexOf(today);
  final start = index < 0 ? 0 : (index ~/ 7) * 7;
  final end = start + 7 > days.length ? days.length : start + 7;
  return days.sublist(start, end);
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({required this.routineId, required this.day});

  final int routineId;
  final PlanDay day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final title = weekdayLabel(day.date.weekday);
    final detail = day.isRest
        ? 'Rest'
        : (day.needsWorkout
              ? 'Choose a workout'
              : (day.workoutName ?? 'Workout'));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: day.logged
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: day.isToday
              ? BorderSide(color: scheme.primary, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          key: Key('plan-${formatIsoDate(day.date)}'),
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push(
            '/routines/$routineId/days/${formatIsoDate(day.date)}',
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleSmall),
                      Text(
                        detail,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  day.canLog
                      ? (day.logged ? 'Edit log' : 'Log session')
                      : 'View',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridHeader extends StatelessWidget {
  const _GridHeader();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const SizedBox(width: 24),
          for (final label in _weekdayInitials)
            Expanded(
              child: Text(label, textAlign: TextAlign.center, style: style),
            ),
        ],
      ),
    );
  }
}

class _GridWeek extends StatelessWidget {
  const _GridWeek({
    required this.routineId,
    required this.week,
    required this.days,
  });

  final int routineId;
  final int week;
  final List<PlanDay> days;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text('$week', style: Theme.of(context).textTheme.labelSmall),
          ),
          for (final day in days)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: _GridCell(routineId: routineId, day: day),
              ),
            ),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.routineId, required this.day});

  final int routineId;
  final PlanDay day;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = day.isRest
        ? scheme.surfaceContainerHighest
        : (day.logged ? scheme.primaryContainer : scheme.secondaryContainer);
    return Tooltip(
      message: day.canLog ? (day.logged ? 'Edit log' : 'Log session') : 'View',
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: day.isToday
              ? BorderSide(color: scheme.primary, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          key: Key('plan-grid-${formatIsoDate(day.date)}'),
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.push(
            '/routines/$routineId/days/${formatIsoDate(day.date)}',
          ),
          child: SizedBox(
            height: 32,
            child: Center(
              child: Text(
                day.shortLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: day.isRest
                      ? scheme.onSurfaceVariant
                      : day.logged
                      ? scheme.onPrimaryContainer
                      : scheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
