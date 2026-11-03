import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/widgets/database_view.dart';

class ActivityCalendar extends ConsumerStatefulWidget {
  const ActivityCalendar({super.key, required this.routineId});

  final int routineId;

  @override
  ConsumerState<ActivityCalendar> createState() => _ActivityCalendarState();
}

class _ActivityCalendarState extends ConsumerState<ActivityCalendar> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final days = ref.watch(activityCalendarProvider(widget.routineId));
    return DatabaseView(
      value: days,
      builder: (context, items) {
        final selected = _selectedDay(items);
        final weeks = <List<ActivityDay>>[];
        for (var index = 0; index < items.length; index += 7) {
          final end = index + 7 > items.length ? items.length : index + 7;
          weeks.add(items.sublist(index, end));
        }
        final theme = Theme.of(context);
        final s = context.s;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Text(
              selected == null
                  ? s.text('Logged workouts')
                  : _caption(s, selected),
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (final label in s.weekdayInitials)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            for (final week in weeks.reversed)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    for (final day in week)
                      Expanded(child: _cell(context, day, selected)),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  ActivityDay? _selectedDay(List<ActivityDay> days) {
    if (days.isEmpty) {
      return null;
    }
    final chosen = _selected;
    if (chosen != null) {
      for (final day in days) {
        if (day.date == chosen) {
          return day;
        }
      }
    }
    for (final day in days) {
      if (day.isToday) {
        return day;
      }
    }
    return days.last;
  }

  String _caption(AppStrings s, ActivityDay day) {
    final date = s.longDate(day.date);
    if (day.logged && day.workoutName != null) {
      return '$date · ${s.workoutName(day.workoutName!)}';
    }
    if (day.planRest) {
      return '$date · ${s.text('Rest')}';
    }
    if (day.planNeedsWorkout) {
      return '$date · ${s.text('Choose a workout')}';
    }
    if (day.planName != null) {
      return '$date · ${s.workoutName(day.planName!)}';
    }
    return '$date · ${s.text('No workout logged')}';
  }

  Widget _cell(BuildContext context, ActivityDay day, ActivityDay? selected) {
    final scheme = Theme.of(context).colorScheme;
    final isSelected = selected != null && selected.date == day.date;
    final showsPlan = day.showsPlan;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: day.logged ? scheme.primary : scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: day.isToday || isSelected
              ? BorderSide(
                  color: day.logged ? scheme.onPrimary : scheme.primary,
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: () => setState(() => _selected = day.date),
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: showsPlan ? 28 : 18,
            child: showsPlan
                ? Center(
                    child: Text(
                      patternCalendarLabel(
                        isRest: day.planRest,
                        needsWorkout: day.planNeedsWorkout,
                        workoutName: day.planName == null
                            ? null
                            : context.s.workoutName(day.planName!),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: day.logged
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
