import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/theme_mode_controller.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.themeMode, required this.child});

  final ThemeModeController themeMode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final onHome = location == '/';
    final onRoutines = location.startsWith('/routines');
    final showMenu = location == '/' || location == '/routines';

    return Scaffold(
      appBar: AppBar(
        title: Text(_title(location)),
        leading: showMenu
            ? Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    tooltip: 'Open menu',
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                },
              )
            : const BackButton(),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: themeMode,
            builder: (context, _) {
              return ListView(
                children: [
                  ListTile(
                    title: const Text('Home'),
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
                    title: const Text('Routines'),
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
                      'Theme',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('System'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                        ),
                      ],
                      selected: {themeMode.mode},
                      onSelectionChanged: (selection) {
                        themeMode.setMode(selection.first);
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

String _title(String location) {
  if (location == '/') {
    return 'Home';
  }
  if (location == '/log' || location.endsWith('/log')) {
    return 'Log session';
  }
  if (location.contains('/days/')) {
    return 'Day';
  }
  if (location.contains('/workouts/')) {
    return 'Workout';
  }
  if (location.contains('/progress')) {
    return 'Progress';
  }
  if (location.startsWith('/routines')) {
    return 'Routines';
  }
  return 'Gym';
}
