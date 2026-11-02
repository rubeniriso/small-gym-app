import 'package:gym_app/domain/exercise.dart';

class RoutineListItem {
  const RoutineListItem({
    required this.id,
    required this.name,
    required this.isCurrent,
    required this.isTemplate,
  });

  final int id;
  final String name;
  final bool isCurrent;
  final bool isTemplate;
}

class WeekdayRow {
  const WeekdayRow({
    required this.weekday,
    required this.isRest,
    required this.workoutId,
    required this.workoutName,
  });

  final int weekday;
  final bool isRest;
  final int? workoutId;
  final String? workoutName;
}

class WorkoutSummary {
  const WorkoutSummary({
    required this.id,
    required this.name,
    required this.position,
  });

  final int id;
  final String name;
  final int position;
}

class PlanDay {
  const PlanDay({
    required this.date,
    required this.isToday,
    required this.isRest,
    required this.needsWorkout,
    required this.workoutName,
    required this.shortLabel,
    required this.logged,
    required this.canLog,
  });

  final DateTime date;
  final bool isToday;
  final bool isRest;
  final bool needsWorkout;
  final String? workoutName;
  final String shortLabel;
  final bool logged;
  final bool canLog;
}

String planShortLabel({
  required bool isRest,
  required bool needsWorkout,
  String? workoutName,
}) {
  if (isRest) {
    return '–';
  }
  if (needsWorkout || workoutName == null || workoutName.trim().isEmpty) {
    return '?';
  }
  final letter = RegExp(r'^Workout ([A-Z])$').firstMatch(workoutName.trim());
  if (letter != null) {
    return letter.group(1)!;
  }
  final trimmed = workoutName.trim();
  if (trimmed.length <= 3) {
    return trimmed;
  }
  return trimmed.substring(0, 1).toUpperCase();
}

class RoutineDetails {
  const RoutineDetails({
    required this.id,
    required this.name,
    required this.isCurrent,
    required this.anchorMonday,
    required this.days,
    required this.workouts,
    required this.startWeightsKg,
  });

  final int id;
  final String name;
  final bool isCurrent;
  final DateTime? anchorMonday;
  final List<WeekdayRow> days;
  final List<WorkoutSummary> workouts;
  final Map<Exercise, double> startWeightsKg;

  bool get isTemplate => anchorMonday != null;
}

class WorkoutExerciseDetails {
  const WorkoutExerciseDetails({
    required this.id,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.position,
    this.targetWeightKg,
    this.targetMinutes,
    this.targetSpeedKmh,
    this.intervals = const [],
  });

  final int id;
  final Exercise exercise;
  final int sets;
  final int reps;
  final int position;
  final double? targetWeightKg;
  final int? targetMinutes;
  final double? targetSpeedKmh;
  final List<LoggedInterval> intervals;
}

class WorkoutDetails {
  const WorkoutDetails({
    required this.id,
    required this.routineId,
    required this.name,
    required this.exercises,
  });

  final int id;
  final int routineId;
  final String name;
  final List<WorkoutExerciseDetails> exercises;
}

class PrescribedExercise {
  const PrescribedExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.weightKg,
    this.targetMinutes,
    this.targetSpeedKmh,
    this.intervals = const [],
  });

  final Exercise exercise;
  final int sets;
  final int reps;
  final double? weightKg;
  final int? targetMinutes;
  final double? targetSpeedKmh;
  final List<LoggedInterval> intervals;
}

class ProgressPoint {
  const ProgressPoint({required this.day, required this.value});

  final DateTime day;
  final double value;
}

class ProgressSeries {
  const ProgressSeries({
    required this.label,
    required this.unit,
    required this.points,
  });

  final String label;
  final String unit;
  final List<ProgressPoint> points;
}

class ExerciseProgress {
  const ExerciseProgress({required this.exercise, required this.series});

  final Exercise exercise;
  final List<ProgressSeries> series;
}

class RoutineExerciseProgress {
  const RoutineExerciseProgress({
    required this.exercise,
    required this.sessions,
    required this.latestLabel,
  });

  final Exercise exercise;
  final int sessions;
  final String? latestLabel;
}

sealed class TodayView {
  const TodayView();
}

class TodayNone extends TodayView {
  const TodayNone();
}

class TodayRest extends TodayView {
  const TodayRest();
}

class TodayNoSession extends TodayView {
  const TodayNoSession();
}

class TodayNeedsWorkout extends TodayView {
  const TodayNeedsWorkout();
}

class TodayWorkout extends TodayView {
  const TodayWorkout({
    required this.workoutId,
    required this.workoutName,
    required this.trainingSlotId,
    required this.logged,
    required this.exercises,
  });

  final int workoutId;
  final String workoutName;
  final int? trainingSlotId;
  final bool logged;
  final List<PrescribedExercise> exercises;
}

class HomeData {
  const HomeData({
    required this.day,
    required this.routineId,
    required this.routineName,
    required this.today,
  });

  final DateTime day;
  final int? routineId;
  final String? routineName;
  final TodayView today;
}

class LoggedInterval {
  const LoggedInterval({
    required this.speedKmh,
    required this.durationSeconds,
    required this.unit,
  });

  final double speedKmh;
  final int durationSeconds;
  final DurationUnit unit;
}

class LoggedLift {
  const LoggedLift({
    required this.exercise,
    required this.weightKg,
    required this.reps,
    this.speedKmh,
    this.durationSeconds,
    this.intervals = const [],
  });

  final Exercise exercise;
  final double weightKg;
  final List<int> reps;
  final double? speedKmh;
  final int? durationSeconds;
  final List<LoggedInterval> intervals;
}

class LogExerciseSeed {
  const LogExerciseSeed({
    required this.exercise,
    required this.sets,
    required this.targetReps,
    required this.weightKg,
    required this.reps,
    this.speedKmh,
    this.durationSeconds,
    this.plan = const [],
    this.completed,
  });

  final Exercise exercise;
  final int sets;
  final int targetReps;
  final double? weightKg;
  final List<int> reps;
  final double? speedKmh;
  final int? durationSeconds;

  /// Sprint targets for the timer. The first interval is the warm-up.
  final List<LoggedInterval> plan;

  /// A sprint already logged today. Null until the timer has been run.
  final List<LoggedInterval>? completed;
}

class LogFormData {
  const LogFormData({
    required this.routineId,
    required this.workoutId,
    required this.trainingSlotId,
    required this.day,
    required this.workoutName,
    required this.updating,
    required this.exercises,
  });

  final int routineId;
  final int workoutId;
  final int? trainingSlotId;
  final DateTime day;
  final String workoutName;
  final bool updating;
  final List<LogExerciseSeed> exercises;
}
