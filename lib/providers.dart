import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/data/gym_repository.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/locale_controller.dart';
import 'package:gym_app/theme_mode_controller.dart';

final themeModeControllerProvider = Provider<ThemeModeController>((ref) {
  final controller = ThemeModeController();
  ref.onDispose(controller.dispose);
  return controller;
});

final localeControllerProvider = Provider<LocaleController>((ref) {
  final controller = LocaleController();
  ref.onDispose(controller.dispose);
  return controller;
});

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Opens the on-device SQLite file. Widget tests get a private memory
/// database so they never touch the phone path.
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final database = Platform.environment.containsKey('FLUTTER_TEST')
      ? AppDatabase.memory()
      : await AppDatabase.openOnDevice();
  ref.onDispose(database.close);
  return database;
});

final repositoryProvider = FutureProvider<GymRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  final repository = GymRepository(database);
  await repository.loadCatalog();
  return repository;
});

final exerciseCatalogProvider = FutureProvider<List<Exercise>>((ref) async {
  ref.watch(dataRevisionProvider);
  final repository = await ref.watch(repositoryProvider.future);
  return repository.exercises();
});

class DataRevision extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final dataRevisionProvider = NotifierProvider<DataRevision, int>(
  DataRevision.new,
);

final homeProvider = FutureProvider<HomeData>((ref) async {
  ref.watch(dataRevisionProvider);
  final repository = await ref.watch(repositoryProvider.future);
  return repository.loadHome(ref.watch(clockProvider)());
});

final routinesProvider = FutureProvider<List<RoutineListItem>>((ref) async {
  ref.watch(dataRevisionProvider);
  final repository = await ref.watch(repositoryProvider.future);
  return repository.listRoutines();
});

final routineDetailsProvider = FutureProvider.family<RoutineDetails, int>((
  ref,
  id,
) async {
  ref.watch(dataRevisionProvider);
  final repository = await ref.watch(repositoryProvider.future);
  return repository.routineDetails(id);
});

final planDaysProvider = FutureProvider.family<List<PlanDay>, int>((
  ref,
  id,
) async {
  ref.watch(dataRevisionProvider);
  final repository = await ref.watch(repositoryProvider.future);
  return repository.planDays(id, ref.watch(clockProvider)());
});

final routineProgressProvider =
    FutureProvider.family<List<RoutineExerciseProgress>, int>((ref, id) async {
      ref.watch(dataRevisionProvider);
      final repository = await ref.watch(repositoryProvider.future);
      return repository.routineProgress(id);
    });

final exerciseProgressProvider =
    FutureProvider.family<
      ExerciseProgress,
      ({int routineId, String exerciseKey, int? targetReps})
    >((ref, key) async {
      ref.watch(dataRevisionProvider);
      final repository = await ref.watch(repositoryProvider.future);
      return repository.exerciseProgress(
        key.routineId,
        Exercise.fromStorage(key.exerciseKey),
        targetReps: key.targetReps,
      );
    });

final routineHomeProvider = FutureProvider.family<HomeData, int>((
  ref,
  id,
) async {
  ref.watch(dataRevisionProvider);
  final repository = await ref.watch(repositoryProvider.future);
  return repository.loadHome(ref.watch(clockProvider)(), routineId: id);
});

final activityCalendarProvider = FutureProvider.family<List<ActivityDay>, int>((
  ref,
  id,
) async {
  ref.watch(dataRevisionProvider);
  final repository = await ref.watch(repositoryProvider.future);
  return repository.activityDays(id, ref.watch(clockProvider)());
});

final dayProvider =
    FutureProvider.family<TodayView, ({int routineId, String iso})>((
      ref,
      key,
    ) async {
      ref.watch(dataRevisionProvider);
      final repository = await ref.watch(repositoryProvider.future);
      return repository.loadDay(key.routineId, parseIsoDate(key.iso));
    });

final workoutDetailsProvider = FutureProvider.family<WorkoutDetails, int>((
  ref,
  id,
) async {
  ref.watch(dataRevisionProvider);
  final repository = await ref.watch(repositoryProvider.future);
  return repository.workoutDetails(id);
});

extension GymMutation on WidgetRef {
  Future<T> mutate<T>(
    Future<T> Function(GymRepository repository) action,
  ) async {
    final repository = await read(repositoryProvider.future);
    final result = await action(repository);
    read(dataRevisionProvider.notifier).bump();
    return result;
  }
}
