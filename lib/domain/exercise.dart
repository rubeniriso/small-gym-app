import 'package:drift/drift.dart';

enum ExerciseKind { strength, jogging, sprinting }

enum Equipment { barbell, dumbbell, none }

enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  arms('Arms'),
  legs('Legs'),
  core('Core'),
  cardio('Cardio');

  const MuscleGroup(this.label);

  final String label;
}

enum DurationUnit {
  seconds('s'),
  minutes('min');

  const DurationUnit(this.storageKey);

  final String storageKey;

  static DurationUnit fromStorage(String? key) {
    return DurationUnit.values.firstWhere(
      (unit) => unit.storageKey == key,
      orElse: () => DurationUnit.seconds,
    );
  }
}

/// Barbell and dumbbell lifts, plus jogging and sprinting.
enum Exercise {
  benchPress(
    'bench_press',
    'Bench Press',
    MuscleGroup.chest,
    Equipment.barbell,
  ),
  inclineBenchPress(
    'incline_bench_press',
    'Incline Bench Press',
    MuscleGroup.chest,
    Equipment.barbell,
  ),
  closeGripBenchPress(
    'close_grip_bench_press',
    'Close-Grip Bench Press',
    MuscleGroup.chest,
    Equipment.barbell,
  ),
  dumbbellBenchPress(
    'dumbbell_bench_press',
    'Dumbbell Bench Press',
    MuscleGroup.chest,
    Equipment.dumbbell,
  ),
  inclineDumbbellPress(
    'incline_dumbbell_press',
    'Incline Dumbbell Press',
    MuscleGroup.chest,
    Equipment.dumbbell,
  ),
  dumbbellFly(
    'dumbbell_fly',
    'Dumbbell Fly',
    MuscleGroup.chest,
    Equipment.dumbbell,
  ),
  deadlift('deadlift', 'Deadlift', MuscleGroup.back, Equipment.barbell),
  romanianDeadlift(
    'romanian_deadlift',
    'Romanian Deadlift',
    MuscleGroup.back,
    Equipment.barbell,
  ),
  barbellRow('barbell_row', 'Barbell Row', MuscleGroup.back, Equipment.barbell),
  pendlayRow('pendlay_row', 'Pendlay Row', MuscleGroup.back, Equipment.barbell),
  dumbbellRow(
    'dumbbell_row',
    'Dumbbell Row',
    MuscleGroup.back,
    Equipment.dumbbell,
  ),
  dumbbellShrug(
    'dumbbell_shrug',
    'Dumbbell Shrug',
    MuscleGroup.back,
    Equipment.dumbbell,
  ),
  overheadPress(
    'overhead_press',
    'Overhead Press',
    MuscleGroup.shoulders,
    Equipment.barbell,
  ),
  dumbbellShoulderPress(
    'dumbbell_shoulder_press',
    'Dumbbell Shoulder Press',
    MuscleGroup.shoulders,
    Equipment.dumbbell,
  ),
  lateralRaise(
    'lateral_raise',
    'Lateral Raise',
    MuscleGroup.shoulders,
    Equipment.dumbbell,
  ),
  rearDeltFly(
    'rear_delt_fly',
    'Rear Delt Fly',
    MuscleGroup.shoulders,
    Equipment.dumbbell,
  ),
  arnoldPress(
    'arnold_press',
    'Arnold Press',
    MuscleGroup.shoulders,
    Equipment.dumbbell,
  ),
  barbellCurl(
    'barbell_curl',
    'Barbell Curl',
    MuscleGroup.arms,
    Equipment.barbell,
  ),
  skullCrusher(
    'skull_crusher',
    'Skull Crusher',
    MuscleGroup.arms,
    Equipment.barbell,
  ),
  dumbbellCurl(
    'dumbbell_curl',
    'Dumbbell Curl',
    MuscleGroup.arms,
    Equipment.dumbbell,
  ),
  hammerCurl(
    'hammer_curl',
    'Hammer Curl',
    MuscleGroup.arms,
    Equipment.dumbbell,
  ),
  overheadTricepsExtension(
    'overhead_triceps_extension',
    'Overhead Triceps Extension',
    MuscleGroup.arms,
    Equipment.dumbbell,
  ),
  squat('squat', 'Squat', MuscleGroup.legs, Equipment.barbell),
  frontSquat('front_squat', 'Front Squat', MuscleGroup.legs, Equipment.barbell),
  hipThrust('hip_thrust', 'Hip Thrust', MuscleGroup.legs, Equipment.barbell),
  barbellLunge(
    'barbell_lunge',
    'Barbell Lunge',
    MuscleGroup.legs,
    Equipment.barbell,
  ),
  goodMorning(
    'good_morning',
    'Good Morning',
    MuscleGroup.legs,
    Equipment.barbell,
  ),
  gobletSquat(
    'goblet_squat',
    'Goblet Squat',
    MuscleGroup.legs,
    Equipment.dumbbell,
  ),
  dumbbellLunge(
    'dumbbell_lunge',
    'Dumbbell Lunge',
    MuscleGroup.legs,
    Equipment.dumbbell,
  ),
  bulgarianSplitSquat(
    'bulgarian_split_squat',
    'Bulgarian Split Squat',
    MuscleGroup.legs,
    Equipment.dumbbell,
  ),
  dumbbellRomanianDeadlift(
    'dumbbell_romanian_deadlift',
    'Dumbbell Romanian Deadlift',
    MuscleGroup.legs,
    Equipment.dumbbell,
  ),
  dumbbellCalfRaise(
    'dumbbell_calf_raise',
    'Dumbbell Calf Raise',
    MuscleGroup.legs,
    Equipment.dumbbell,
  ),
  dumbbellRussianTwist(
    'dumbbell_russian_twist',
    'Dumbbell Russian Twist',
    MuscleGroup.core,
    Equipment.dumbbell,
  ),
  weightedCrunch(
    'weighted_crunch',
    'Weighted Crunch',
    MuscleGroup.core,
    Equipment.dumbbell,
  ),
  dumbbellSideBend(
    'dumbbell_side_bend',
    'Dumbbell Side Bend',
    MuscleGroup.core,
    Equipment.dumbbell,
  ),
  jogging(
    'jogging',
    'Jogging',
    MuscleGroup.cardio,
    Equipment.none,
    ExerciseKind.jogging,
  ),
  sprinting(
    'sprinting',
    'Sprinting',
    MuscleGroup.cardio,
    Equipment.none,
    ExerciseKind.sprinting,
  );

  const Exercise(
    this.storageKey,
    this.label,
    this.muscleGroup,
    this.equipment, [
    this.kind = ExerciseKind.strength,
  ]);

  final String storageKey;
  final String label;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final ExerciseKind kind;

  /// The five lifts of the 12-week template. Other exercises are not part of it.
  static const strongLifts = <Exercise>[
    squat,
    deadlift,
    benchPress,
    overheadPress,
    barbellRow,
  ];

  String get detail {
    final gear = switch (equipment) {
      Equipment.barbell => 'Barbell',
      Equipment.dumbbell => 'Dumbbell',
      Equipment.none => null,
    };
    if (gear == null) {
      return muscleGroup.label;
    }
    return '$gear · ${muscleGroup.label}';
  }

  static Exercise fromStorage(String key) {
    return Exercise.values.firstWhere(
      (exercise) => exercise.storageKey == key,
      orElse: () => throw ArgumentError.value(key, 'exercise'),
    );
  }
}

class ExerciseConverter extends TypeConverter<Exercise, String> {
  const ExerciseConverter();

  @override
  Exercise fromSql(String fromDb) => Exercise.fromStorage(fromDb);

  @override
  String toSql(Exercise value) => value.storageKey;
}
