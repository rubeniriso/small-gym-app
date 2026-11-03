import 'package:go_router/go_router.dart';
import 'package:gym_app/screens/autopilot_screen.dart';
import 'package:gym_app/screens/create_template_screen.dart';
import 'package:gym_app/screens/day_screen.dart';
import 'package:gym_app/screens/exercises_screen.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/screens/log_session_screen.dart';
import 'package:gym_app/screens/progress_screen.dart';
import 'package:gym_app/screens/routine_editor_screen.dart';
import 'package:gym_app/screens/routines_screen.dart';
import 'package:gym_app/screens/workout_editor_screen.dart';
import 'package:gym_app/locale_controller.dart';
import 'package:gym_app/theme_mode_controller.dart';
import 'package:gym_app/widgets/app_shell.dart';

GoRouter createRouter(ThemeModeController themeMode, LocaleController locale) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return AppShell(
            themeMode: themeMode,
            locale: locale,
            child: const HomeScreen(),
          );
        },
      ),
      GoRoute(
        path: '/autopilot',
        builder: (context, state) {
          return AppShell(
            themeMode: themeMode,
            locale: locale,
            child: const AutopilotScreen(),
          );
        },
      ),
      GoRoute(
        path: '/log',
        builder: (context, state) {
          return AppShell(
            themeMode: themeMode,
            locale: locale,
            child: const LogSessionScreen(),
          );
        },
      ),
      GoRoute(
        path: '/exercises',
        builder: (context, state) {
          return AppShell(
            themeMode: themeMode,
            locale: locale,
            child: const ExercisesScreen(),
          );
        },
      ),
      GoRoute(
        path: '/routines',
        builder: (context, state) {
          return AppShell(
            themeMode: themeMode,
            locale: locale,
            child: const RoutinesScreen(),
          );
        },
        routes: [
          GoRoute(
            path: 'new/template',
            builder: (context, state) {
              return AppShell(
                themeMode: themeMode,
                locale: locale,
                child: const CreateTemplateScreen(),
              );
            },
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return AppShell(
                themeMode: themeMode,
                locale: locale,
                child: RoutineEditorScreen(routineId: id),
              );
            },
            routes: [
              GoRoute(
                path: 'days/:iso',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AppShell(
                    themeMode: themeMode,
                    locale: locale,
                    child: DayScreen(
                      routineId: id,
                      iso: state.pathParameters['iso']!,
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'autopilot',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AppShell(
                    themeMode: themeMode,
                    locale: locale,
                    child: AutopilotScreen(routineId: id),
                  );
                },
              ),
              GoRoute(
                path: 'log',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AppShell(
                    themeMode: themeMode,
                    locale: locale,
                    child: LogSessionScreen(routineId: id),
                  );
                },
              ),
              GoRoute(
                path: 'progress',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AppShell(
                    themeMode: themeMode,
                    locale: locale,
                    child: ProgressScreen(routineId: id),
                  );
                },
                routes: [
                  GoRoute(
                    path: ':exerciseKey',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      final reps = int.tryParse(
                        state.uri.queryParameters['reps'] ?? '',
                      );
                      return AppShell(
                        themeMode: themeMode,
                        locale: locale,
                        child: ExerciseProgressScreen(
                          routineId: id,
                          exerciseKey: state.pathParameters['exerciseKey']!,
                          targetReps: reps,
                        ),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'workouts/:workoutId',
                builder: (context, state) {
                  final workoutId = int.parse(
                    state.pathParameters['workoutId']!,
                  );
                  return AppShell(
                    themeMode: themeMode,
                    locale: locale,
                    child: WorkoutEditorScreen(workoutId: workoutId),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
