import 'package:flutter/material.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/routine_kind.dart';
import 'package:gym_app/domain/sprint.dart';

/// English and Spanish copy for the app. English strings stay the source
/// text so the existing screens can keep their wording.
class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  bool get es => locale.languageCode.toLowerCase() == 'es';

  String text(String english) {
    if (!es) {
      return english;
    }
    return _es[english] ?? english;
  }

  String exerciseName(Exercise exercise) {
    if (!es || exercise.custom) {
      return exercise.label;
    }
    return _exerciseEs[exercise.storageKey] ?? exercise.label;
  }

  String exerciseDetail(Exercise exercise) {
    return '${equipment(exercise.equipment)} · ${muscleGroup(exercise.muscleGroup)}';
  }

  String muscleGroup(MuscleGroup group) => text(group.label);

  String equipment(Equipment equipment) => text(equipment.label);

  String routineKind(RoutineKind kind) => text(kind.label);

  /// Default template names and the generated "Workout" / "Workout 2" labels.
  /// Names the user typed stay as they were saved.
  String workoutName(String name) {
    if (!es) {
      return name;
    }
    if (name == 'Workout') {
      return text('Workout');
    }
    final letter = RegExp(r'^Workout ([A-Z])$').firstMatch(name);
    if (letter != null) {
      return 'Entrenamiento ${letter.group(1)}';
    }
    final number = RegExp(r'^Workout (\d+)$').firstMatch(name);
    if (number != null) {
      return 'Entrenamiento ${number.group(1)}';
    }
    return name;
  }

  String defaultWorkoutName(int existingCount) {
    if (existingCount <= 0) {
      return text('Workout');
    }
    final number = existingCount + 1;
    return es ? 'Entrenamiento $number' : 'Workout $number';
  }

  String weekday(int weekday) {
    if (!es) {
      return weekdayLabel(weekday);
    }
    final name = _weekdaysEs[weekday - 1];
    return name[0].toUpperCase() + name.substring(1);
  }

  List<String> get weekdayInitials =>
      es ? _weekdayInitialsEs : _weekdayInitialsEn;

  String longDate(DateTime value) {
    if (!es) {
      return formatLongDate(value);
    }
    final day = dateOnly(value);
    final weekday = _weekdaysEs[day.weekday - 1];
    final month = _monthsEs[day.month - 1];
    return '$weekday, ${day.day} de $month de ${day.year}';
  }

  String chartDay(DateTime day) {
    final months = es ? _shortMonthsEs : _shortMonthsEn;
    return '${day.day} ${months[day.month - 1]}';
  }

  String startsOn(DateTime value) {
    final date = longDate(value);
    return es ? 'Empieza el $date' : 'Starts $date';
  }

  String weekOneStarts(DateTime value) {
    final date = longDate(value);
    return es ? 'La semana 1 empieza el $date' : 'Week 1 starts $date';
  }

  String setOf(int number, int total) =>
      es ? 'Serie $number de $total' : 'Set $number of $total';

  String intervalLabel(int number) =>
      es ? 'Intervalo $number' : 'Interval $number';

  String nextUp(String name) => es ? 'Siguiente: $name' : 'Next: $name';

  String fewer(String label) =>
      es ? 'Menos ${label.toLowerCase()}' : 'Fewer ${label.toLowerCase()}';

  String more(String label) =>
      es ? 'Más ${label.toLowerCase()}' : 'More ${label.toLowerCase()}';

  String exerciseWithReps(Exercise exercise, int reps) {
    final name = exerciseName(exercise);
    return es ? '$name · $reps repeticiones' : '$name · $reps reps';
  }

  String progressTitle({
    required Exercise exercise,
    required String title,
    int? targetReps,
  }) {
    if (!es) {
      return title;
    }
    final name = exerciseName(exercise);
    if (title == exercise.label) {
      return name;
    }
    const marker = ' · ';
    const suffix = ' reps';
    if (title.startsWith(exercise.label) && title.endsWith(suffix)) {
      final middle = title.substring(exercise.label.length);
      if (middle.startsWith(marker) && middle.endsWith(suffix)) {
        final reps = middle.substring(
          marker.length,
          middle.length - suffix.length,
        );
        return '$name$marker$reps repeticiones';
      }
    }
    if (targetReps != null &&
        title == '${exercise.label}$marker$targetReps$suffix') {
      return exerciseWithReps(exercise, targetReps);
    }
    return title.replaceFirst(exercise.label, name);
  }

  String seriesLabel(String label) => text(label);

  String prescription(PrescribedExercise exercise) {
    if (!es) {
      return describePrescription(exercise);
    }
    switch (exercise.exercise.kind) {
      case ExerciseKind.jogging:
        final duration = exercise.targetDurationSeconds;
        final speed = exercise.targetSpeedKmh;
        if (duration != null && speed != null) {
          return '${formatDuration(duration)} · ${formatKg(speed)} km/h';
        }
        return text('Duration · km/h');
      case ExerciseKind.sprinting:
        final count = exercise.intervals.isEmpty
            ? exercise.sets
            : exercise.intervals.length;
        return count == 1 ? '1 intervalo' : '$count intervalos';
      case ExerciseKind.strength:
        return describePrescription(exercise);
    }
  }

  String sprintLine(LoggedInterval interval, int index) {
    final name = index == 0 ? text('Warm-up') : intervalLabel(index + 1);
    return '$name · ${formatKg(interval.speedKmh)} km/h · ${formatSprintDuration(interval)}';
  }

  String jogLine({int? durationSeconds, double? speedKmh}) {
    if (durationSeconds != null && speedKmh != null) {
      return '${formatDuration(durationSeconds)} · ${formatKg(speedKmh)} km/h';
    }
    return text('Duration · km/h');
  }

  String todayMessage(TodayView? today) {
    return switch (today) {
      null || TodayNone() => text('No current routine.'),
      TodayRest() => text('Rest'),
      TodayNoSession() => text('This plan has no session today.'),
      TodayNeedsWorkout() => text('Choose a workout for today.'),
      TodayWorkout() => text('Log session'),
    };
  }

  String planCaption(PlanDay? today) {
    if (today == null) {
      return text('This plan has no session today.');
    }
    if (today.canLog) {
      final name = workoutName(today.workoutName ?? 'Workout');
      return es
          ? 'Hoy toca $name. Toca un día para ver el entrenamiento.'
          : 'Today is $name. Tap a day to see the workout.';
    }
    if (today.isRest) {
      return text('Today is rest. Tap a day to see the workout.');
    }
    if (today.needsWorkout) {
      return text('Choose a workout for today. Tap a day to see the workout.');
    }
    return text('This plan has no session today.');
  }

  String patternDay(int position, {required bool rest, String? workoutName}) {
    if (rest) {
      return '$position  ${text('Rest')}';
    }
    final name = workoutName == null
        ? text('Workout')
        : this.workoutName(workoutName);
    return '$position  $name';
  }

  String errorMessage(Object error, {String? fallback}) {
    if (error is ArgumentError && error.message is String) {
      return text(error.message! as String);
    }
    return text(fallback ?? 'Could not open the database.');
  }
}

class AppStringsScope extends InheritedWidget {
  const AppStringsScope({
    super.key,
    required this.strings,
    required super.child,
  });

  final AppStrings strings;

  static AppStrings of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStringsScope>();
    return scope?.strings ?? const AppStrings(Locale('en'));
  }

  @override
  bool updateShouldNotify(AppStringsScope oldWidget) =>
      oldWidget.strings.locale.languageCode != strings.locale.languageCode;
}

extension AppStringsContext on BuildContext {
  AppStrings get s => AppStringsScope.of(this);
}

const _weekdaysEs = <String>[
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo',
];

const _monthsEs = <String>[
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

const _shortMonthsEn = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const _shortMonthsEs = <String>[
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

const _weekdayInitialsEn = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

const _weekdayInitialsEs = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá', 'Do'];

const _exerciseEs = <String, String>{
  'bench_press': 'Press de banca',
  'incline_bench_press': 'Press de banca inclinado',
  'close_grip_bench_press': 'Press de banca agarre cerrado',
  'dumbbell_bench_press': 'Press de banca con mancuernas',
  'incline_dumbbell_press': 'Press inclinado con mancuernas',
  'dumbbell_fly': 'Aperturas con mancuernas',
  'cable_fly': 'Aperturas en polea',
  'cable_crossover': 'Cruces en polea',
  'deadlift': 'Peso muerto',
  'romanian_deadlift': 'Peso muerto rumano',
  'barbell_row': 'Remo con barra',
  'pendlay_row': 'Remo Pendlay',
  'dumbbell_row': 'Remo con mancuerna',
  'dumbbell_shrug': 'Encogimientos con mancuernas',
  'lat_pulldown': 'Jalón al pecho',
  'seated_cable_row': 'Remo en polea',
  'straight_arm_pulldown': 'Jalón de brazos rectos',
  'overhead_press': 'Press militar',
  'dumbbell_shoulder_press': 'Press de hombros con mancuernas',
  'lateral_raise': 'Elevaciones laterales',
  'rear_delt_fly': 'Pájaros',
  'arnold_press': 'Press Arnold',
  'face_pull': 'Tirón a la cara',
  'cable_lateral_raise': 'Elevaciones laterales en polea',
  'barbell_curl': 'Curl con barra',
  'skull_crusher': 'Rompecráneos',
  'dumbbell_curl': 'Curl con mancuernas',
  'hammer_curl': 'Curl martillo',
  'cable_curl': 'Curl en polea',
  'overhead_triceps_extension': 'Extensión de tríceps por encima de la cabeza',
  'triceps_pushdown': 'Jalón de tríceps',
  'overhead_cable_extension': 'Extensión de tríceps en polea',
  'squat': 'Sentadilla',
  'front_squat': 'Sentadilla frontal',
  'hip_thrust': 'Hip thrust',
  'barbell_lunge': 'Zancadas con barra',
  'good_morning': 'Buenos días',
  'goblet_squat': 'Sentadilla goblet',
  'dumbbell_lunge': 'Zancadas con mancuernas',
  'bulgarian_split_squat': 'Sentadilla búlgara',
  'dumbbell_romanian_deadlift': 'Peso muerto rumano con mancuernas',
  'dumbbell_calf_raise': 'Elevación de gemelos con mancuernas',
  'cable_pull_through': 'Pase entre las piernas en polea',
  'cable_kickback': 'Patada de glúteo en polea',
  'dumbbell_russian_twist': 'Giros rusos con mancuerna',
  'weighted_crunch': 'Encogimientos con peso',
  'dumbbell_side_bend': 'Flexión lateral con mancuerna',
  'cable_crunch': 'Encogimientos en polea',
  'cable_woodchop': 'Leñador en polea',
  'jogging': 'Trote',
  'sprinting': 'Sprint',
};

const _es = <String, String>{
  'Gym': 'Gimnasio',
  'Home': 'Inicio',
  'Exercises': 'Ejercicios',
  'Routines': 'Rutinas',
  'Open menu': 'Abrir menú',
  'Theme': 'Tema',
  'System': 'Sistema',
  'Light': 'Claro',
  'Dark': 'Oscuro',
  'Language': 'Idioma',
  'English': 'Inglés',
  'Spanish': 'Español',
  'Log session': 'Registrar sesión',
  'Edit log': 'Editar registro',
  'Autopilot': 'Piloto automático',
  'Day': 'Día',
  'Workout': 'Entrenamiento',
  'Progress': 'Progreso',
  'No current routine.': 'No hay una rutina actual.',
  'Rest': 'Descanso',
  'This plan has no session today.': 'Este plan no tiene sesión hoy.',
  'Choose a workout for today.': 'Elige un entrenamiento para hoy.',
  'Open routine': 'Abrir rutina',
  'Edit pattern': 'Editar patrón',
  'Edit week': 'Editar semana',
  'Choose a workout.': 'Elige un entrenamiento.',
  'No routines yet.': 'Todavía no hay rutinas.',
  '12-week plan': 'Plan de 12 semanas',
  'Dynamic': 'Dinámica',
  'Custom Pattern': 'Patrón personalizado',
  'Static': 'Estática',
  'Delete routine': 'Borrar rutina',
  'Create routine': 'Crear rutina',
  'Create': 'Crear',
  'Empty routine': 'Rutina vacía',
  '12-week template': 'Plantilla de 12 semanas',
  'Import template': 'Importar plantilla',
  'Delete this routine?': '¿Borrar esta rutina?',
  'Cancel': 'Cancelar',
  'Delete': 'Borrar',
  'New routine': 'Nueva rutina',
  'Name': 'Nombre',
  'Type': 'Tipo',
  'Enter a name.': 'Escribe un nombre.',
  'Numbered days repeat on the calendar.':
      'Los días numerados se repiten en el calendario.',
  'Paste a template.': 'Pega una plantilla.',
  'That file is not a template.': 'Ese archivo no es una plantilla.',
  'Template JSON': 'JSON de la plantilla',
  'Import': 'Importar',
  'Share': 'Compartir',
  'Make dynamic': 'Hacer dinámica',
  'Change type': 'Cambiar tipo',
  'Charts': 'Gráficas',
  'Calendar': 'Calendario',
  'Summary': 'Resumen',
  'Plan': 'Plan',
  'Workouts': 'Entrenamientos',
  'Make this routine dynamic?': '¿Hacer dinámica esta rutina?',
  'The week will stop deciding the workout. You choose it each day.':
      'La semana dejará de decidir el entrenamiento. Lo eliges cada día.',
  'Template copied.': 'Plantilla copiada.',
  'Add a workout, then choose it for today.':
      'Añade un entrenamiento y elígelo para hoy.',
  'Choose any workout for today. The next one is only a suggestion.': 'Elige cualquier entrenamiento para hoy. El siguiente es solo una sugerencia.',
  'Add a workout in Workouts.': 'Añade un entrenamiento en Entrenamientos.',
  'Today': 'Hoy',
  'Do today': 'Hacer hoy',
  'Starting weights': 'Pesos iniciales',
  'This routine is dynamic. Pick the workout each day.':
      'Esta rutina es dinámica. Elige el entrenamiento cada día.',
  'New workout': 'Nuevo entrenamiento',
  'Assign these workouts to numbered days on Plan.':
      'Asigna estos entrenamientos a días numerados en Plan.',
  'Week': 'Semana',
  'Edit': 'Editar',
  'Change': 'Cambiar',
  'Choose a workout': 'Elegir un entrenamiento',
  'Pattern': 'Patrón',
  'Numbered days repeat from the start date. After the last day, the sequence starts again.': 'Los días numerados se repiten desde la fecha de inicio. Después del último día, la secuencia vuelve a empezar.',
  'Choose a start date': 'Elige una fecha de inicio',
  'Add a day to build the sequence.': 'Añade un día para crear la secuencia.',
  'Add day': 'Añadir día',
  'Remove': 'Quitar',
  'This week': 'Esta semana',
  'Today is rest. Tap a day to see the workout.':
      'Hoy es descanso. Toca un día para ver el entrenamiento.',
  'Choose a workout for today. Tap a day to see the workout.':
      'Elige un entrenamiento para hoy. Toca un día para ver el entrenamiento.',
  'View': 'Ver',
  'Logged workouts': 'Entrenamientos registrados',
  'No workout logged': 'Sin entrenamiento registrado',
  'Add exercise': 'Añadir ejercicio',
  'Add an exercise.': 'Añade un ejercicio.',
  'Remove exercise': 'Quitar ejercicio',
  'Done': 'Hecho',
  'Duration': 'Duración',
  'Speed (km/h)': 'Velocidad (km/h)',
  'Add the warm-up and each interval.':
      'Añade el calentamiento y cada intervalo.',
  'Add intervals': 'Añadir intervalos',
  'Edit intervals': 'Editar intervalos',
  'Sets': 'Series',
  'Reps': 'Repeticiones',
  'Weight (kg)': 'Peso (kg)',
  'Weight increments': 'Incrementos de peso',
  'Duration · km/h': 'Duración · km/h',
  'Warm-up': 'Calentamiento',
  'The first interval is the warm-up.':
      'El primer intervalo es el calentamiento.',
  'Set the target for this exercise.': 'Fija el objetivo de este ejercicio.',
  'Add interval': 'Añadir intervalo',
  'Remove interval': 'Quitar intervalo',
  'Add': 'Añadir',
  'Save': 'Guardar',
  'Enter a weight.': 'Escribe un peso.',
  'Enter a duration.': 'Escribe una duración.',
  'Enter a speed.': 'Escribe una velocidad.',
  'Enter a duration for every interval.':
      'Escribe una duración para cada intervalo.',
  'Enter a speed for every interval.':
      'Escribe una velocidad para cada intervalo.',
  'Update session': 'Actualizar sesión',
  'Add sprint intervals in the workout.':
      'Añade los intervalos de sprint en el entrenamiento.',
  'Run the sprint timer.': 'Usa el cronómetro de sprint.',
  'Sprint complete.': 'Sprint completado.',
  'Run again': 'Correr otra vez',
  'Start': 'Empezar',
  'Get ready': 'Prepárate',
  'Sprint': 'Sprint',
  'Interval': 'Intervalo',
  'Stop': 'Parar',
  'Next': 'Siguiente',
  'Skip': 'Saltar',
  'Last set': 'Última serie',
  'Autopilot is for strength sets. Intervals stay on the log.': 'El piloto automático es para las series de fuerza. Los intervalos se quedan en el registro.',
  'Edit set': 'Editar serie',
  'Enter reps for every set.': 'Escribe las repeticiones de cada serie.',
  'No sessions yet': 'Todavía no hay sesiones',
  'No sessions logged yet.': 'Todavía no hay sesiones registradas.',
  'Add an exercise to a workout to see progress.':
      'Añade un ejercicio a un entrenamiento para ver el progreso.',
  'Weight': 'Peso',
  'Speed': 'Velocidad',
  'Minutes': 'Minutos',
  'Peak speed': 'Velocidad máxima',
  'Week 1 Monday': 'Lunes de la semana 1',
  'Choose a Monday': 'Elige un lunes',
  'Choose a Monday.': 'Elige un lunes.',
  'Enter a weight for every exercise.': 'Escribe un peso para cada ejercicio.',
  'Workout A and Workout B alternate on Monday, Wednesday, and Friday for 12 weeks.': 'El entrenamiento A y el entrenamiento B se alternan los lunes, miércoles y viernes durante 12 semanas.',
  'Could not create the routine.': 'No se pudo crear la rutina.',
  'Could not open the database.': 'No se pudo abrir la base de datos.',
  'New exercise': 'Nuevo ejercicio',
  'Muscle group': 'Grupo muscular',
  'Equipment': 'Equipamiento',
  'That exercise already exists.': 'Ese ejercicio ya existe.',
  'Nothing left in this group.': 'No queda nada en este grupo.',
  'No exercises in this group.': 'No hay ejercicios en este grupo.',
  'No exercises match.': 'Ningún ejercicio coincide.',
  'Tap to set': 'Toca para fijar',
  'Use routine default': 'Usar el de la rutina',
  'Routine default': 'El de la rutina',
  'Amount': 'Cantidad',
  'Enter an amount.': 'Escribe una cantidad.',
  'Enter the rest.': 'Escribe el descanso.',
  'Enter sets.': 'Escribe las series.',
  'Enter reps.': 'Escribe las repeticiones.',
  'That exercise is already in this workout.':
      'Ese ejercicio ya está en este entrenamiento.',
  'That exercise is gone.': 'Ese ejercicio ya no está.',
  'That routine is gone.': 'Esa rutina ya no está.',
  'That workout is gone.': 'Ese entrenamiento ya no está.',
  'That workout is not in this routine.':
      'Ese entrenamiento no está en esta rutina.',
  'That day is gone.': 'Ese día ya no está.',
  'Choose a day of the week.': 'Elige un día de la semana.',
  'Choose a day.': 'Elige un día.',
  'This routine is not a custom pattern.':
      'Esta rutina no es un patrón personalizado.',
  'Each exercise is logged once.': 'Cada ejercicio se registra una vez.',
  'That training day is not in this routine.':
      'Ese día de entreno no está en esta rutina.',
  'That exercise is not a strength set.':
      'Ese ejercicio no es una serie de fuerza.',
  'Add a warm-up interval.': 'Añade un intervalo de calentamiento.',
  'Add a day to the pattern.': 'Añade un día al patrón.',
  'All': 'Todos',
  'Chest': 'Pecho',
  'Back': 'Espalda',
  'Shoulders': 'Hombros',
  'Biceps': 'Bíceps',
  'Triceps': 'Tríceps',
  'Legs': 'Piernas',
  'Core': 'Core',
  'Cardio': 'Cardio',
  'Barbell': 'Barra',
  'Cable': 'Polea',
  'Dumbbell': 'Mancuernas',
  'Bodyweight': 'Peso corporal',
  'Jogging': 'Trote',
  'Sprinting': 'Sprint',
};
