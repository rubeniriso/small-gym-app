import 'package:go_router/go_router.dart';
import 'package:gym_app/screens/create_template_screen.dart';
import 'package:gym_app/screens/day_screen.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/screens/log_session_screen.dart';
import 'package:gym_app/screens/progress_screen.dart';
import 'package:gym_app/screens/routine_editor_screen.dart';
import 'package:gym_app/screens/routines_screen.dart';
import 'package:gym_app/screens/workout_editor_screen.dart';
import 'package:gym_app/theme_mode_controller.dart';
import 'package:gym_app/widgets/app_shell.dart';

GoRouter createRouter(ThemeModeController themeMode) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return AppShell(themeMode: themeMode, child: const HomeScreen());
        },
      ),
      GoRoute(
        path: '/log',
        builder: (context, state) {
          return AppShell(
            themeMode: themeMode,
            child: const LogSessionScreen(),
          );
        },
      ),
      GoRoute(
        path: '/routines',
        builder: (context, state) {
          return AppShell(themeMode: themeMode, child: const RoutinesScreen());
        },
        routes: [
          GoRoute(
            path: 'new/template',
            builder: (context, state) {
              return AppShell(
                themeMode: themeMode,
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
                    child: DayScreen(
                      routineId: id,
                      iso: state.pathParameters['iso']!,
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'log',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AppShell(
                    themeMode: themeMode,
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
                    child: ProgressScreen(routineId: id),
                  );
                },
                routes: [
                  GoRoute(
                    path: ':exerciseKey',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return AppShell(
                        themeMode: themeMode,
                        child: ExerciseProgressScreen(
                          routineId: id,
                          exerciseKey: state.pathParameters['exerciseKey']!,
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
