import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/locale_controller.dart';
import 'package:gym_app/theme_mode_controller.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.themeMode,
    required this.locale,
    required this.child,
  });

  final ThemeModeController themeMode;
  final LocaleController locale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final location = GoRouterState.of(context).matchedLocation;
    final onHome = location == '/';
    final onRoutines = location.startsWith('/routines');
    final onExercises = location == '/exercises';
    final showMenu =
        location == '/' || location == '/routines' || location == '/exercises';

    return Scaffold(
      appBar: AppBar(
        title: Text(_title(s, location)),
        leading: showMenu
            ? Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    tooltip: s.text('Open menu'),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                },
              )
            : const BackButton(),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: Listenable.merge([themeMode, locale]),
            builder: (context, _) {
              final copy = context.s;
              return ListView(
                children: [
                  ListTile(
                    title: Text(copy.text('Home')),
                    selected: onHome,
                    onTap: () {
                      final router = GoRouter.of(context);
                      Navigator.pop(context);
                      if (onHome) {
                        return;
                      }
                      router.go('/');
                    },
                  ),
                  ListTile(
                    title: Text(copy.text('Exercises')),
                    selected: onExercises,
                    onTap: () {
                      final router = GoRouter.of(context);
                      Navigator.pop(context);
                      if (onExercises) {
                        return;
                      }
                      if (location == '/') {
                        router.push('/exercises');
                      } else {
                        router.go('/exercises');
                      }
                    },
                  ),
                  ListTile(
                    title: Text(copy.text('Routines')),
                    selected: onRoutines,
                    onTap: () {
                      final router = GoRouter.of(context);
                      Navigator.pop(context);
                      if (location == '/routines') {
                        return;
                      }
                      if (location == '/') {
                        router.push('/routines');
                      } else {
                        router.go('/routines');
                      }
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      copy.text('Theme'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text(
                            copy.text('System'),
                            key: const Key('theme-system'),
                          ),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text(
                            copy.text('Light'),
                            key: const Key('theme-light'),
                          ),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text(
                            copy.text('Dark'),
                            key: const Key('theme-dark'),
                          ),
                        ),
                      ],
                      selected: {themeMode.mode},
                      onSelectionChanged: (selection) {
                        themeMode.setMode(selection.first);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      copy.text('Language'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: SegmentedButton<AppLanguage>(
                      showSelectedIcon: false,
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      segments: [
                        ButtonSegment(
                          value: AppLanguage.system,
                          label: Text(
                            copy.text('System'),
                            key: const Key('language-system'),
                          ),
                        ),
                        ButtonSegment(
                          value: AppLanguage.english,
                          label: Text(
                            copy.text('English'),
                            key: const Key('language-english'),
                          ),
                        ),
                        ButtonSegment(
                          value: AppLanguage.spanish,
                          label: Text(
                            copy.text('Spanish'),
                            key: const Key('language-spanish'),
                          ),
                        ),
                      ],
                      selected: {locale.language},
                      onSelectionChanged: (selection) {
                        locale.setLanguage(selection.first);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: child,
    );
  }
}

String _title(AppStrings s, String location) {
  if (location == '/') {
    return s.text('Home');
  }
  if (location == '/log' || location.endsWith('/log')) {
    return s.text('Log session');
  }
  if (location == '/autopilot' || location.endsWith('/autopilot')) {
    return s.text('Autopilot');
  }
  if (location.contains('/days/')) {
    return s.text('Day');
  }
  if (location.contains('/workouts/')) {
    return s.text('Workout');
  }
  if (location.contains('/progress')) {
    return s.text('Progress');
  }
  if (location == '/exercises') {
    return s.text('Exercises');
  }
  if (location.startsWith('/routines')) {
    return s.text('Routines');
  }
  return s.text('Gym');
}
