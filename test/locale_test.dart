import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/app.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/locale_controller.dart';

void main() {
  test('system language uses Spanish only when the platform is Spanish', () {
    final controller = LocaleController();
    expect(controller.resolve(const Locale('es', 'ES')).languageCode, 'es');
    expect(controller.resolve(const Locale('es')).languageCode, 'es');
    expect(controller.resolve(const Locale('en', 'US')).languageCode, 'en');
    expect(controller.resolve(const Locale('fr')).languageCode, 'en');

    controller.setLanguage(AppLanguage.spanish);
    expect(controller.resolve(const Locale('en')).languageCode, 'es');

    controller.setLanguage(AppLanguage.english);
    expect(controller.resolve(const Locale('es')).languageCode, 'en');
  });

  test('built-in lifts keep a recognizable Spanish name', () {
    const spanish = AppStrings(Locale('es'));
    expect(spanish.exerciseName(Exercise.squat), 'Sentadilla');
    expect(spanish.exerciseName(Exercise.benchPress), 'Press de banca');
    expect(spanish.exerciseName(Exercise.deadlift), 'Peso muerto');
    expect(spanish.exerciseName(Exercise.overheadPress), 'Press militar');
    expect(spanish.exerciseName(Exercise.barbellRow), 'Remo con barra');
    expect(spanish.exerciseName(Exercise.hipThrust), 'Hip thrust');
    expect(spanish.exerciseName(Exercise.arnoldPress), 'Press Arnold');
    expect(spanish.exerciseName(Exercise.latPulldown), 'Jalón al pecho');
    expect(spanish.exerciseName(Exercise.cableCurl), 'Curl en polea');
    expect(spanish.exerciseName(Exercise.tricepsPushdown), 'Jalón de tríceps');
    expect(spanish.text('All'), 'Todos');
    expect(spanish.muscleGroup(MuscleGroup.chest), 'Pecho');
    expect(spanish.muscleGroup(MuscleGroup.back), 'Espalda');
    expect(spanish.equipment(Equipment.cable), 'Polea');
    expect(spanish.equipment(Equipment.barbell), 'Barra');
    expect(spanish.equipment(Equipment.dumbbell), 'Mancuernas');
    for (final exercise in Exercise.builtIn) {
      expect(
        spanish.exerciseName(exercise),
        isNot(exercise.label),
        reason: exercise.storageKey,
      );
    }

    final custom = Exercise(
      storageKey: 'custom_face_pull',
      label: 'Face Pull',
      muscleGroup: MuscleGroup.shoulders,
      equipment: Equipment.dumbbell,
      custom: true,
    );
    expect(spanish.exerciseName(custom), 'Face Pull');
  });

  testWidgets('the drawer switches the UI to Spanish', (tester) async {
    await tester.pumpWidget(const GymApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('No current routine.'), findsOneWidget);

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language-spanish')));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('No hay una rutina actual.'), findsOneWidget);
    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);

    await tester.tap(find.byKey(const Key('language-english')));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('No current routine.'), findsOneWidget);
  });
}
