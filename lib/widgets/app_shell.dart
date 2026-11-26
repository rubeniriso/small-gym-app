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
              final theme = Theme.of(context);
              final scheme = theme.colorScheme;
              Widget section(String label) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              );
              return ListTileTheme.merge(
                selectedColor: scheme.onPrimaryContainer,
                selectedTileColor: scheme.primaryContainer,
                iconColor: scheme.onSurfaceVariant,
                shape: const StadiumBorder(),
                minTileHeight: 56,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              size: 22,
                              color: scheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            copy.text('Gym'),
                            style: theme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
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
                      leading: const Icon(Icons.fitness_center),
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
                      leading: const Icon(Icons.calendar_month_outlined),
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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Divider(height: 1),
                    ),
                    section(copy.text('Theme')),
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
                    section(copy.text('Language')),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                ),
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
