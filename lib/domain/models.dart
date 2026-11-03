import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/routine_kind.dart';
import 'package:gym_app/domain/schedule.dart';

/// Rest between strength sets when an exercise does not override it.
const defaultRestSeconds = 90;

/// Added after a finished session when an exercise does not override it.
const standardIncrement = WeightIncrement(
  unit: IncrementUnit.kilograms,
  amount: 2.5,
);

enum IncrementUnit {
  kilograms('kg'),
  percent('percent');

  const IncrementUnit(this.storageKey);

  final String storageKey;

  String get label => this == IncrementUnit.kilograms ? 'kg' : '%';

  static IncrementUnit fromStorage(String? key) {
    return IncrementUnit.values.firstWhere(
      (unit) => unit.storageKey == key,
      orElse: () => IncrementUnit.kilograms,
    );
  }
}

class WeightIncrement {
  const WeightIncrement({required this.unit, required this.amount});

  final IncrementUnit unit;
  final double amount;
}

class RoutineListItem {
  const RoutineListItem({
    required this.id,
    required this.name,
    required this.isCurrent,
    required this.isTemplate,
    required this.kind,
  });

  final int id;
  final String name;
  final bool isCurrent;
  final bool isTemplate;
  final RoutineKind kind;
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

/// One numbered day in a custom pattern. [position] starts at 1.
class PatternDayRow {
  const PatternDayRow({
    required this.position,
    required this.isRest,
    required this.workoutId,
    required this.workoutName,
  });

  final int position;
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

/// Calendar label for a custom-pattern day. Short names stay whole.
String patternCalendarLabel({
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
  final trimmed = workoutName.trim();
  if (trimmed.length <= 4) {
    return trimmed;
  }
  return trimmed.substring(0, 3);
}

class RoutineDetails {
  const RoutineDetails({
    required this.id,
    required this.name,
    required this.isCurrent,
    required this.anchorMonday,
    required this.kind,
    this.increment = standardIncrement,
    this.restSeconds = defaultRestSeconds,
    required this.days,
    required this.workouts,
    required this.startWeightsKg,
    this.patternStart,
    this.pattern = const [],
  });

  final int id;
  final String name;
  final bool isCurrent;
  final DateTime? anchorMonday;
  final RoutineKind kind;
  final WeightIncrement increment;
  final int restSeconds;
  final List<WeekdayRow> days;
  final List<WorkoutSummary> workouts;
  final Map<Exercise, double> startWeightsKg;

  /// First calendar day of a custom pattern. Null for other routines.
  final DateTime? patternStart;
  final List<PatternDayRow> pattern;

  bool get isTemplate => anchorMonday != null;
  bool get isStatic => kind == RoutineKind.staticWeek;
  bool get isDynamic => kind == RoutineKind.dynamicDay;
  bool get isPattern => kind == RoutineKind.customPattern;

  /// Pattern entry that falls on [day], or null when this is not a pattern
  /// or the sequence is empty.
  PatternDayRow? stepOn(DateTime day) {
    if (patternStart == null || pattern.isEmpty) {
      return null;
    }
    return pattern[patternIndex(
      start: patternStart!,
      day: day,
      length: pattern.length,
    )];
  }
}

class WorkoutExerciseDetails {
  const WorkoutExerciseDetails({
    required this.id,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.position,
    this.targetWeightKg,
    this.targetDurationSeconds,
    this.targetSpeedKmh,
    this.restSeconds,
    this.increment,
    this.intervals = const [],
  });

  final int id;
  final Exercise exercise;
  final int sets;
  final int reps;
  final int position;
  final double? targetWeightKg;

  /// Jogging length in seconds.
  final int? targetDurationSeconds;
  final double? targetSpeedKmh;

  /// Null uses the routine rest.
  final int? restSeconds;

  /// Null uses the routine increment.
  final WeightIncrement? increment;
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
    this.targetDurationSeconds,
    this.targetSpeedKmh,
    this.restSeconds = defaultRestSeconds,
    this.intervals = const [],
  });

  final Exercise exercise;
  final int sets;
  final int reps;
  final double? weightKg;

  /// Jogging length in seconds.
  final int? targetDurationSeconds;
  final double? targetSpeedKmh;

  /// Rest after a set of this exercise. Already resolved from the routine.
  final int restSeconds;
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
    required this.title,
    required this.sessions,
    required this.latestLabel,
    this.targetReps,
  });

  final Exercise exercise;
  final String title;
  final int? targetReps;
  final int sessions;
  final String? latestLabel;
}

class ActivityDay {
  const ActivityDay({
    required this.date,
    required this.logged,
    required this.isToday,
    this.workoutName,
    this.planName,
    this.planRest = false,
    this.planNeedsWorkout = false,
  });

  final DateTime date;
  final bool logged;
  final bool isToday;
  final String? workoutName;

  /// Workout a custom pattern assigns to this date. Null for other routines.
  final String? planName;
  final bool planRest;
  final bool planNeedsWorkout;

  bool get showsPlan => planRest || planNeedsWorkout || planName != null;
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
    this.choices = const [],
  });

  final int workoutId;
  final String workoutName;
  final int? trainingSlotId;
  final bool logged;
  final List<PrescribedExercise> exercises;

  /// Other workouts the user can do today. Empty on a static routine.
  final List<WorkoutSummary> choices;

  bool get hasStrength => exercises.any(
    (exercise) => exercise.exercise.kind == ExerciseKind.strength,
  );
}

class HomeData {
  const HomeData({
    required this.day,
    required this.routineId,
    required this.routineName,
    required this.today,
    this.kind,
  });

  final DateTime day;
  final int? routineId;
  final String? routineName;
  final TodayView today;
  final RoutineKind? kind;
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
    this.targetReps,
    this.setWeights,
    this.speedKmh,
    this.durationSeconds,
    this.intervals = const [],
  });

  final Exercise exercise;
  final double weightKg;
  final List<int> reps;

  /// One weight per set. Null entries fall back to [weightKg].
  final List<double?>? setWeights;

  /// Rep target of the planned slot, so 4-rep and 8-rep logs stay apart.
  final int? targetReps;
  final double? speedKmh;
  final int? durationSeconds;
  final List<LoggedInterval> intervals;
}

class LogExerciseSeed {
  const LogExerciseSeed({
    required this.exercise,
    required this.sets,
    required this.targetReps,
    this.substitute,
    required this.weightKg,
    required this.reps,
    this.speedKmh,
    this.durationSeconds,
    this.plan = const [],
    this.completed,
    this.strengthSets = const [],
    this.restSeconds = defaultRestSeconds,
  });

  final Exercise exercise;

  /// Logged in place of [exercise] for this session only.
  final Exercise? substitute;
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

  /// Planned strength sets. Empty for cardio.
  final List<StrengthSet> strengthSets;
  final int restSeconds;
}

class StrengthSet {
  const StrengthSet({
    required this.placeholderKg,
    required this.placeholderReps,
    this.loggedKg,
    this.loggedReps,
  });

  final double placeholderKg;
  final int placeholderReps;
  final double? loggedKg;
  final int? loggedReps;

  bool get done => loggedReps != null;

  double get displayKg => loggedKg ?? placeholderKg;
  int get displayReps => loggedReps ?? placeholderReps;
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
