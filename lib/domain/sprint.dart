import 'dart:math' as math;

import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';

/// 12 o'clock. A positive sweep moves clockwise on Flutter's canvas.
const sprintRingStartAngle = -math.pi / 2;

double sprintRingSweep(double progress) {
  final clamped = progress < 0 ? 0.0 : (progress > 1 ? 1.0 : progress);
  return 2 * math.pi * clamped;
}

String formatDuration(int totalSeconds) {
  final safe = totalSeconds < 0 ? 0 : totalSeconds;
  final minutes = safe ~/ 60;
  final seconds = safe % 60;
  if (minutes == 0) {
    return '$seconds s';
  }
  if (seconds == 0) {
    return '$minutes min';
  }
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

String formatSprintDuration(LoggedInterval interval) {
  return formatDuration(interval.durationSeconds);
}

String sprintObjective(LoggedInterval interval, int index) {
  final name = index == 0 ? 'Warm-up' : 'Interval ${index + 1}';
  return '$name · ${formatKg(interval.speedKmh)} km/h · ${formatSprintDuration(interval)}';
}

String describePrescription(PrescribedExercise exercise) {
  switch (exercise.exercise.kind) {
    case ExerciseKind.jogging:
      final duration = exercise.targetDurationSeconds;
      final speed = exercise.targetSpeedKmh;
      if (duration != null && speed != null) {
        return '${formatDuration(duration)} · ${formatKg(speed)} km/h';
      }
      return 'Duration · km/h';
    case ExerciseKind.sprinting:
      final count = exercise.intervals.isEmpty
          ? exercise.sets
          : exercise.intervals.length;
      return count == 1 ? '1 interval' : '$count intervals';
    case ExerciseKind.strength:
      final volume = '${exercise.sets} × ${exercise.reps}';
      final weight = exercise.weightKg;
      if (weight == null) {
        return volume;
      }
      return '$volume · ${formatKg(weight)} kg';
  }
}

String formatCountdown(Duration remaining) {
  final millis = remaining.inMilliseconds;
  if (millis <= 0) {
    return '0';
  }
  final shown = (millis / 1000).ceil();
  final minutes = shown ~/ 60;
  final seconds = shown % 60;
  if (minutes == 0) {
    return '$seconds';
  }
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

enum SprintPhaseKind { idle, grace, interval, done }

class SprintPhase {
  const SprintPhase({
    required this.kind,
    required this.intervalIndex,
    required this.progress,
    required this.remaining,
  });

  final SprintPhaseKind kind;
  final int intervalIndex;
  final double progress;
  final Duration remaining;

  int number(int total) =>
      intervalIndex + 1 > total ? total : intervalIndex + 1;
}

SprintPhase sprintPhase({
  required bool started,
  required Duration elapsed,
  required Duration grace,
  required List<LoggedInterval> intervals,
}) {
  final first = intervals.isEmpty
      ? Duration.zero
      : Duration(seconds: intervals.first.durationSeconds);
  if (!started || intervals.isEmpty) {
    return SprintPhase(
      kind: SprintPhaseKind.idle,
      intervalIndex: 0,
      progress: 0,
      remaining: first,
    );
  }
  if (grace > Duration.zero && elapsed < grace) {
    return SprintPhase(
      kind: SprintPhaseKind.grace,
      intervalIndex: 0,
      progress: _ratio(elapsed, grace),
      remaining: grace - elapsed,
    );
  }
  var cursor = elapsed - grace;
  if (cursor.isNegative) {
    cursor = Duration.zero;
  }
  for (var index = 0; index < intervals.length; index++) {
    final length = Duration(seconds: intervals[index].durationSeconds);
    if (length <= Duration.zero) {
      continue;
    }
    if (cursor < length) {
      return SprintPhase(
        kind: SprintPhaseKind.interval,
        intervalIndex: index,
        progress: _ratio(cursor, length),
        remaining: length - cursor,
      );
    }
    cursor -= length;
  }
  final last = intervals.length - 1;
  return SprintPhase(
    kind: SprintPhaseKind.done,
    intervalIndex: last < 0 ? 0 : last,
    progress: 1,
    remaining: Duration.zero,
  );
}

double _ratio(Duration elapsed, Duration total) {
  if (total <= Duration.zero) {
    return 1;
  }
  final value = elapsed.inMicroseconds / total.inMicroseconds;
  if (value < 0) {
    return 0;
  }
  if (value > 1) {
    return 1;
  }
  return value;
}
