import 'package:drift/drift.dart';

enum ExerciseKind {
  strength,
  jogging,
  sprinting;

  static ExerciseKind fromStorage(String? key) {
    return ExerciseKind.values.firstWhere(
      (kind) => kind.name == key,
      orElse: () => ExerciseKind.strength,
    );
  }
}

enum Equipment {
  barbell('Barbell'),
  cable('Cable'),
  dumbbell('Dumbbell'),

  /// No equipment.
  none('Bodyweight');

  const Equipment(this.label);

  final String label;

  static Equipment fromStorage(String key) {
    return Equipment.values.firstWhere(
      (equipment) => equipment.name == key,
      orElse: () => throw ArgumentError.value(key, 'equipment'),
    );
  }
}

enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  biceps('Biceps'),
  triceps('Triceps'),
  legs('Legs'),
  core('Core'),
  cardio('Cardio');

  const MuscleGroup(this.label);

  final String label;

  static MuscleGroup fromStorage(String key) {
    return MuscleGroup.values.firstWhere(
      (group) => group.name == key,
      orElse: () => throw ArgumentError.value(key, 'muscleGroup'),
    );
  }
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

/// A built-in or user-created exercise. Built-ins are fixed. Custom ones are
/// registered from the database before any row that names them is read.
class Exercise {
  const Exercise({
    required this.storageKey,
    required this.label,
    required this.muscleGroup,
    required this.equipment,
    this.kind = ExerciseKind.strength,
    this.custom = false,
  });

  final String storageKey;
  final String label;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final ExerciseKind kind;
  final bool custom;

  static const benchPress = Exercise(
    storageKey: 'bench_press',
    label: 'Bench Press',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.barbell,
  );
  static const inclineBenchPress = Exercise(
    storageKey: 'incline_bench_press',
    label: 'Incline Bench Press',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.barbell,
  );
  static const closeGripBenchPress = Exercise(
    storageKey: 'close_grip_bench_press',
    label: 'Close-Grip Bench Press',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.barbell,
  );
  static const dumbbellBenchPress = Exercise(
    storageKey: 'dumbbell_bench_press',
    label: 'Dumbbell Bench Press',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.dumbbell,
  );
  static const inclineDumbbellPress = Exercise(
    storageKey: 'incline_dumbbell_press',
    label: 'Incline Dumbbell Press',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.dumbbell,
  );
  static const dumbbellFly = Exercise(
    storageKey: 'dumbbell_fly',
    label: 'Dumbbell Fly',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.dumbbell,
  );
  static const cableFly = Exercise(
    storageKey: 'cable_fly',
    label: 'Cable Fly',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.cable,
  );
  static const cableCrossover = Exercise(
    storageKey: 'cable_crossover',
    label: 'Cable Crossover',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.cable,
  );
  static const deadlift = Exercise(
    storageKey: 'deadlift',
    label: 'Deadlift',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
  );
  static const romanianDeadlift = Exercise(
    storageKey: 'romanian_deadlift',
    label: 'Romanian Deadlift',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
  );
  static const barbellRow = Exercise(
    storageKey: 'barbell_row',
    label: 'Barbell Row',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
  );
  static const pendlayRow = Exercise(
    storageKey: 'pendlay_row',
    label: 'Pendlay Row',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.barbell,
  );
  static const dumbbellRow = Exercise(
    storageKey: 'dumbbell_row',
    label: 'Dumbbell Row',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.dumbbell,
  );
  static const dumbbellShrug = Exercise(
    storageKey: 'dumbbell_shrug',
    label: 'Dumbbell Shrug',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.dumbbell,
  );
  static const latPulldown = Exercise(
    storageKey: 'lat_pulldown',
    label: 'Lat Pulldown',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.cable,
  );
  static const seatedCableRow = Exercise(
    storageKey: 'seated_cable_row',
    label: 'Seated Cable Row',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.cable,
  );
  static const straightArmPulldown = Exercise(
    storageKey: 'straight_arm_pulldown',
    label: 'Straight-Arm Pulldown',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.cable,
  );
  static const overheadPress = Exercise(
    storageKey: 'overhead_press',
    label: 'Overhead Press',
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.barbell,
  );
  static const dumbbellShoulderPress = Exercise(
    storageKey: 'dumbbell_shoulder_press',
    label: 'Dumbbell Shoulder Press',
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.dumbbell,
  );
  static const lateralRaise = Exercise(
    storageKey: 'lateral_raise',
    label: 'Lateral Raise',
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.dumbbell,
  );
  static const rearDeltFly = Exercise(
    storageKey: 'rear_delt_fly',
    label: 'Rear Delt Fly',
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.dumbbell,
  );
  static const arnoldPress = Exercise(
    storageKey: 'arnold_press',
    label: 'Arnold Press',
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.dumbbell,
  );
  static const facePull = Exercise(
    storageKey: 'face_pull',
    label: 'Face Pull',
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.cable,
  );
  static const cableLateralRaise = Exercise(
    storageKey: 'cable_lateral_raise',
    label: 'Cable Lateral Raise',
    muscleGroup: MuscleGroup.shoulders,
    equipment: Equipment.cable,
  );
  static const barbellCurl = Exercise(
    storageKey: 'barbell_curl',
    label: 'Barbell Curl',
    muscleGroup: MuscleGroup.biceps,
    equipment: Equipment.barbell,
  );
  static const skullCrusher = Exercise(
    storageKey: 'skull_crusher',
    label: 'Skull Crusher',
    muscleGroup: MuscleGroup.triceps,
    equipment: Equipment.barbell,
  );
  static const dumbbellCurl = Exercise(
    storageKey: 'dumbbell_curl',
    label: 'Dumbbell Curl',
    muscleGroup: MuscleGroup.biceps,
    equipment: Equipment.dumbbell,
  );
  static const hammerCurl = Exercise(
    storageKey: 'hammer_curl',
    label: 'Hammer Curl',
    muscleGroup: MuscleGroup.biceps,
    equipment: Equipment.dumbbell,
  );
  static const cableCurl = Exercise(
    storageKey: 'cable_curl',
    label: 'Cable Curl',
    muscleGroup: MuscleGroup.biceps,
    equipment: Equipment.cable,
  );
  static const overheadTricepsExtension = Exercise(
    storageKey: 'overhead_triceps_extension',
    label: 'Overhead Triceps Extension',
    muscleGroup: MuscleGroup.triceps,
    equipment: Equipment.dumbbell,
  );
  static const tricepsPushdown = Exercise(
    storageKey: 'triceps_pushdown',
    label: 'Triceps Pushdown',
    muscleGroup: MuscleGroup.triceps,
    equipment: Equipment.cable,
  );
  static const overheadCableExtension = Exercise(
    storageKey: 'overhead_cable_extension',
    label: 'Overhead Cable Extension',
    muscleGroup: MuscleGroup.triceps,
    equipment: Equipment.cable,
  );
  static const squat = Exercise(
    storageKey: 'squat',
    label: 'Squat',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
  );
  static const frontSquat = Exercise(
    storageKey: 'front_squat',
    label: 'Front Squat',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
  );
  static const hipThrust = Exercise(
    storageKey: 'hip_thrust',
    label: 'Hip Thrust',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
  );
  static const barbellLunge = Exercise(
    storageKey: 'barbell_lunge',
    label: 'Barbell Lunge',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
  );
  static const goodMorning = Exercise(
    storageKey: 'good_morning',
    label: 'Good Morning',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.barbell,
  );
  static const gobletSquat = Exercise(
    storageKey: 'goblet_squat',
    label: 'Goblet Squat',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.dumbbell,
  );
  static const dumbbellLunge = Exercise(
    storageKey: 'dumbbell_lunge',
    label: 'Dumbbell Lunge',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.dumbbell,
  );
  static const bulgarianSplitSquat = Exercise(
    storageKey: 'bulgarian_split_squat',
    label: 'Bulgarian Split Squat',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.dumbbell,
  );
  static const dumbbellRomanianDeadlift = Exercise(
    storageKey: 'dumbbell_romanian_deadlift',
    label: 'Dumbbell Romanian Deadlift',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.dumbbell,
  );
  static const dumbbellCalfRaise = Exercise(
    storageKey: 'dumbbell_calf_raise',
    label: 'Dumbbell Calf Raise',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.dumbbell,
  );
  static const cablePullThrough = Exercise(
    storageKey: 'cable_pull_through',
    label: 'Cable Pull-Through',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.cable,
  );
  static const cableKickback = Exercise(
    storageKey: 'cable_kickback',
    label: 'Cable Kickback',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.cable,
  );
  static const dumbbellRussianTwist = Exercise(
    storageKey: 'dumbbell_russian_twist',
    label: 'Dumbbell Russian Twist',
    muscleGroup: MuscleGroup.core,
    equipment: Equipment.dumbbell,
  );
  static const weightedCrunch = Exercise(
    storageKey: 'weighted_crunch',
    label: 'Weighted Crunch',
    muscleGroup: MuscleGroup.core,
    equipment: Equipment.dumbbell,
  );
  static const dumbbellSideBend = Exercise(
    storageKey: 'dumbbell_side_bend',
    label: 'Dumbbell Side Bend',
    muscleGroup: MuscleGroup.core,
    equipment: Equipment.dumbbell,
  );
  static const cableCrunch = Exercise(
    storageKey: 'cable_crunch',
    label: 'Cable Crunch',
    muscleGroup: MuscleGroup.core,
    equipment: Equipment.cable,
  );
  static const cableWoodchop = Exercise(
    storageKey: 'cable_woodchop',
    label: 'Cable Woodchop',
    muscleGroup: MuscleGroup.core,
    equipment: Equipment.cable,
  );
  static const jogging = Exercise(
    storageKey: 'jogging',
    label: 'Jogging',
    muscleGroup: MuscleGroup.cardio,
    equipment: Equipment.none,
    kind: ExerciseKind.jogging,
  );
  static const sprinting = Exercise(
    storageKey: 'sprinting',
    label: 'Sprinting',
    muscleGroup: MuscleGroup.cardio,
    equipment: Equipment.none,
    kind: ExerciseKind.sprinting,
  );

  /// The five lifts of the 12-week template. Other exercises are not part of it.
  static const strongLifts = <Exercise>[
    squat,
    deadlift,
    benchPress,
    overheadPress,
    barbellRow,
  ];

  static const builtIn = <Exercise>[
    benchPress,
    inclineBenchPress,
    closeGripBenchPress,
    dumbbellBenchPress,
    inclineDumbbellPress,
    dumbbellFly,
    cableFly,
    cableCrossover,
    deadlift,
    romanianDeadlift,
    barbellRow,
    pendlayRow,
    dumbbellRow,
    dumbbellShrug,
    latPulldown,
    seatedCableRow,
    straightArmPulldown,
    overheadPress,
    dumbbellShoulderPress,
    lateralRaise,
    rearDeltFly,
    arnoldPress,
    facePull,
    cableLateralRaise,
    barbellCurl,
    skullCrusher,
    dumbbellCurl,
    hammerCurl,
    cableCurl,
    overheadTricepsExtension,
    tricepsPushdown,
    overheadCableExtension,
    squat,
    frontSquat,
    hipThrust,
    barbellLunge,
    goodMorning,
    gobletSquat,
    dumbbellLunge,
    bulgarianSplitSquat,
    dumbbellRomanianDeadlift,
    dumbbellCalfRaise,
    cablePullThrough,
    cableKickback,
    dumbbellRussianTwist,
    weightedCrunch,
    dumbbellSideBend,
    cableCrunch,
    cableWoodchop,
    jogging,
    sprinting,
  ];

  static final _byKey = <String, Exercise>{
    for (final exercise in builtIn) exercise.storageKey: exercise,
  };

  static List<Exercise> get catalog {
    final builtInOrder = {
      for (var index = 0; index < builtIn.length; index++)
        builtIn[index].storageKey: index,
    };
    final exercises = _byKey.values.toList();
    exercises.sort((a, b) {
      final group = a.muscleGroup.index.compareTo(b.muscleGroup.index);
      if (group != 0) {
        return group;
      }
      final aOrder = builtInOrder[a.storageKey] ?? builtIn.length;
      final bOrder = builtInOrder[b.storageKey] ?? builtIn.length;
      final order = aOrder.compareTo(bOrder);
      if (order != 0) {
        return order;
      }
      return a.label.toLowerCase().compareTo(b.label.toLowerCase());
    });
    return exercises;
  }

  static bool known(String key) => _byKey.containsKey(key);

  /// Keeps the first exercise registered for a key. Built-ins win.
  static Exercise register(Exercise exercise) {
    final existing = _byKey[exercise.storageKey];
    if (existing != null) {
      return existing;
    }
    _byKey[exercise.storageKey] = exercise;
    return exercise;
  }

  /// Drops previously loaded custom exercises and installs [custom].
  static void replaceCustomExercises(Iterable<Exercise> custom) {
    _byKey.removeWhere((_, exercise) => exercise.custom);
    for (final exercise in custom) {
      final existing = _byKey[exercise.storageKey];
      if (existing != null && !existing.custom) {
        continue;
      }
      _byKey[exercise.storageKey] = exercise;
    }
  }

  String get detail => '${equipment.label} · ${muscleGroup.label}';

  static Exercise fromStorage(String key) {
    final exercise = _byKey[key];
    if (exercise == null) {
      throw ArgumentError.value(key, 'exercise');
    }
    return exercise;
  }

  @override
  bool operator ==(Object other) =>
      other is Exercise && other.storageKey == storageKey;

  @override
  int get hashCode => storageKey.hashCode;

  @override
  String toString() => label;
}

class ExerciseConverter extends TypeConverter<Exercise, String> {
  const ExerciseConverter();

  @override
  Exercise fromSql(String fromDb) => Exercise.fromStorage(fromDb);

  @override
  String toSql(Exercise value) => value.storageKey;
}
