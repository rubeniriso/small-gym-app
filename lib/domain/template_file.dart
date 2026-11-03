import 'dart:convert';

import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/routine_kind.dart';

class TemplateFile {
  const TemplateFile({
    required this.name,
    required this.kind,
    required this.increment,
    required this.workouts,
    this.restSeconds = defaultRestSeconds,
    this.anchorMonday,
    this.startWeightsKg = const {},
    this.customExercises = const [],
    this.weekdays = const [],
    this.slots = const [],
    this.patternStart,
    this.pattern = const [],
  });

  final String name;
  final RoutineKind kind;
  final WeightIncrement increment;
  final int restSeconds;
  final String? anchorMonday;
  final Map<Exercise, double> startWeightsKg;
  final List<Exercise> customExercises;
  final List<TemplateWeekday> weekdays;
  final List<TemplateWorkout> workouts;

  /// Workout names in session order. Empty when the week itself assigns them.
  final List<String> slots;

  /// First calendar day of a custom pattern.
  final String? patternStart;
  final List<TemplatePatternDay> pattern;
}

class TemplateWeekday {
  const TemplateWeekday({
    required this.weekday,
    required this.isRest,
    this.workoutName,
  });

  final int weekday;
  final bool isRest;
  final String? workoutName;
}

class TemplatePatternDay {
  const TemplatePatternDay({
    required this.position,
    required this.isRest,
    this.workoutName,
  });

  final int position;
  final bool isRest;
  final String? workoutName;
}

class TemplateWorkout {
  const TemplateWorkout({required this.name, required this.exercises});

  final String name;
  final List<TemplateExercise> exercises;
}

class TemplateExercise {
  const TemplateExercise({
    required this.exercise,
    required this.sets,
    required this.reps,
    this.targetWeightKg,
    this.targetDurationSeconds,
    this.targetSpeedKmh,
    this.restSeconds,
    this.increment,
    this.intervals = const [],
  });

  final Exercise exercise;
  final int sets;
  final int reps;
  final double? targetWeightKg;

  /// Jogging length in seconds.
  final int? targetDurationSeconds;
  final double? targetSpeedKmh;
  final int? restSeconds;

  /// Null uses the routine increment.
  final WeightIncrement? increment;
  final List<TemplateInterval> intervals;
}

class TemplateInterval {
  const TemplateInterval({
    required this.speedKmh,
    required this.durationSeconds,
    required this.unit,
  });

  final double speedKmh;
  final int durationSeconds;
  final DurationUnit unit;
}

String encodeTemplate(TemplateFile file) {
  return const JsonEncoder.withIndent('  ').convert(_toMap(file));
}

TemplateFile decodeTemplate(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! Map) {
    throw ArgumentError('That file is not a template.');
  }
  final map = Map<String, Object?>.from(decoded);
  if (map['format'] != 'gym-template') {
    throw ArgumentError('That file is not a template.');
  }
  final name = map['name'];
  if (name is! String || name.trim().isEmpty) {
    throw ArgumentError('Enter a name.');
  }
  final customExercises = _customExercises(map['customExercises']);
  final workouts = map['workouts'];
  return TemplateFile(
    name: name.trim(),
    kind: RoutineKind.fromStorage(map['kind'] as String?),
    increment: _routineIncrement(map),
    restSeconds: map['restSeconds'] is int
        ? map['restSeconds']! as int
        : defaultRestSeconds,
    anchorMonday: map['anchorMonday'] as String?,
    startWeightsKg: _weights(map['startWeightsKg']),
    customExercises: customExercises,
    weekdays: [
      if (map['weekdays'] is List)
        for (final day in map['weekdays'] as List)
          if (day is Map) _weekday(Map<String, Object?>.from(day)),
    ],
    slots: [
      if (map['slots'] is List)
        for (final slot in map['slots'] as List)
          if (slot is String) slot,
    ],
    patternStart: map['patternStart'] as String?,
    pattern: [
      if (map['pattern'] is List)
        for (final day in map['pattern'] as List)
          if (day is Map) _patternDay(Map<String, Object?>.from(day)),
    ],
    workouts: [
      if (workouts is List)
        for (final workout in workouts)
          if (workout is Map) _workout(Map<String, Object?>.from(workout)),
    ],
  );
}

Map<String, Object?> _toMap(TemplateFile file) {
  return {
    'format': 'gym-template',
    'version': 1,
    'name': file.name,
    'kind': file.kind.storageKey,
    'increments': file.increment.amount > 0,
    'incrementAmount': file.increment.amount,
    'incrementUnit': file.increment.unit.storageKey,
    'restSeconds': file.restSeconds,
    'anchorMonday': file.anchorMonday,
    if (file.customExercises.isNotEmpty)
      'customExercises': [
        for (final exercise in file.customExercises)
          {
            'key': exercise.storageKey,
            'name': exercise.label,
            'muscleGroup': exercise.muscleGroup.name,
            'equipment': exercise.equipment.name,
            'kind': exercise.kind.name,
          },
      ],
    'startWeightsKg': {
      for (final entry in file.startWeightsKg.entries)
        entry.key.storageKey: entry.value,
    },
    'weekdays': [
      for (final day in file.weekdays)
        {
          'weekday': day.weekday,
          'isRest': day.isRest,
          'workout': day.workoutName,
        },
    ],
    'slots': file.slots,
    if (file.kind == RoutineKind.customPattern)
      'patternStart': file.patternStart,
    if (file.kind == RoutineKind.customPattern)
      'pattern': [
        for (final day in file.pattern)
          {
            'position': day.position,
            'isRest': day.isRest,
            'workout': day.workoutName,
          },
      ],
    'workouts': [
      for (final workout in file.workouts)
        {
          'name': workout.name,
          'exercises': [
            for (final exercise in workout.exercises)
              {
                'exercise': exercise.exercise.storageKey,
                'sets': exercise.sets,
                'reps': exercise.reps,
                'targetWeightKg': exercise.targetWeightKg,
                'targetMinutes': exercise.targetDurationSeconds == null
                    ? null
                    : exercise.targetDurationSeconds! ~/ 60,
                'targetDurationSeconds': exercise.targetDurationSeconds,
                'targetSpeedKmh': exercise.targetSpeedKmh,
                'restSeconds': exercise.restSeconds,
                'incrementAmount': exercise.increment?.amount,
                'incrementUnit': exercise.increment?.unit.storageKey,
                'intervals': [
                  for (final interval in exercise.intervals)
                    {
                      'speedKmh': interval.speedKmh,
                      'durationSeconds': interval.durationSeconds,
                      'unit': interval.unit.storageKey,
                    },
                ],
              },
          ],
        },
    ],
  };
}

List<Exercise> _customExercises(Object? value) {
  if (value is! List) {
    return const [];
  }
  final exercises = <Exercise>[];
  for (final item in value) {
    if (item is! Map) {
      continue;
    }
    final map = Map<String, Object?>.from(item);
    final key = map['key'];
    final name = map['name'];
    final muscle = map['muscleGroup'];
    final equipment = map['equipment'];
    if (key is! String ||
        name is! String ||
        name.trim().isEmpty ||
        muscle is! String ||
        equipment is! String) {
      throw ArgumentError('That file is not a template.');
    }
    final registered = Exercise.register(
      Exercise(
        storageKey: key,
        label: name.trim(),
        muscleGroup: MuscleGroup.fromStorage(muscle),
        equipment: Equipment.fromStorage(equipment),
        kind: ExerciseKind.fromStorage(map['kind'] as String?),
        custom: true,
      ),
    );
    if (registered.custom) {
      exercises.add(registered);
    }
  }
  return exercises;
}

Map<Exercise, double> _weights(Object? value) {
  if (value is! Map) {
    return const {};
  }
  final weights = <Exercise, double>{};
  for (final entry in value.entries) {
    final weight = entry.value;
    if (entry.key is String && weight is num) {
      weights[Exercise.fromStorage(entry.key as String)] = weight.toDouble();
    }
  }
  return weights;
}

TemplateWeekday _weekday(Map<String, Object?> day) {
  return TemplateWeekday(
    weekday: day['weekday'] is int ? day['weekday']! as int : DateTime.monday,
    isRest: day['isRest'] == true,
    workoutName: day['workout'] as String?,
  );
}

TemplatePatternDay _patternDay(Map<String, Object?> day) {
  return TemplatePatternDay(
    position: day['position'] is int ? day['position']! as int : 1,
    isRest: day['isRest'] == true,
    workoutName: day['workout'] as String?,
  );
}

TemplateWorkout _workout(Map<String, Object?> workout) {
  final exercises = workout['exercises'];
  return TemplateWorkout(
    name: workout['name'] is String ? workout['name']! as String : 'Workout',
    exercises: [
      if (exercises is List)
        for (final exercise in exercises)
          if (exercise is Map) _exercise(Map<String, Object?>.from(exercise)),
    ],
  );
}

WeightIncrement _routineIncrement(Map<String, Object?> map) {
  final amount = map['incrementAmount'];
  final unit = map['incrementUnit'];
  if (amount is num && unit is String) {
    return WeightIncrement(
      unit: IncrementUnit.fromStorage(unit),
      amount: amount.toDouble(),
    );
  }
  if (map['increments'] == false) {
    return const WeightIncrement(unit: IncrementUnit.kilograms, amount: 0);
  }
  return standardIncrement;
}

WeightIncrement? _incrementOverride(Map<String, Object?> exercise) {
  final amount = exercise['incrementAmount'];
  final unit = exercise['incrementUnit'];
  if (amount is! num || unit is! String) {
    return null;
  }
  return WeightIncrement(
    unit: IncrementUnit.fromStorage(unit),
    amount: amount.toDouble(),
  );
}

int? _joggingSeconds(Map<String, Object?> exercise) {
  final exact = exercise['targetDurationSeconds'];
  if (exact is int) {
    return exact;
  }
  final minutes = exercise['targetMinutes'];
  if (minutes is int) {
    return minutes * 60;
  }
  return null;
}

TemplateExercise _exercise(Map<String, Object?> exercise) {
  final intervals = exercise['intervals'];
  return TemplateExercise(
    exercise: Exercise.fromStorage(exercise['exercise'] as String? ?? ''),
    sets: exercise['sets'] is int ? exercise['sets']! as int : 1,
    reps: exercise['reps'] is int ? exercise['reps']! as int : 1,
    targetWeightKg: exercise['targetWeightKg'] is num
        ? (exercise['targetWeightKg'] as num).toDouble()
        : null,
    targetDurationSeconds: _joggingSeconds(exercise),
    targetSpeedKmh: exercise['targetSpeedKmh'] is num
        ? (exercise['targetSpeedKmh'] as num).toDouble()
        : null,
    restSeconds: exercise['restSeconds'] is int
        ? exercise['restSeconds'] as int
        : null,
    increment: _incrementOverride(exercise),
    intervals: [
      if (intervals is List)
        for (final interval in intervals)
          if (interval is Map) _interval(Map<String, Object?>.from(interval)),
    ],
  );
}

TemplateInterval _interval(Map<String, Object?> interval) {
  return TemplateInterval(
    speedKmh: interval['speedKmh'] is num
        ? (interval['speedKmh'] as num).toDouble()
        : 0,
    durationSeconds: interval['durationSeconds'] is int
        ? interval['durationSeconds']! as int
        : 0,
    unit: DurationUnit.fromStorage(interval['unit'] as String?),
  );
}
