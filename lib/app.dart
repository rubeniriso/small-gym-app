import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/router.dart';
import 'package:gym_app/theme_mode_controller.dart';

class GymApp extends StatelessWidget {
  const GymApp({super.key, this.themeMode, this.database, this.clock});

  final ThemeModeController? themeMode;
  final AppDatabase? database;
  final DateTime Function()? clock;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        if (themeMode != null)
          themeModeControllerProvider.overrideWithValue(themeMode!),
        if (database != null) databaseProvider.overrideWith((ref) => database!),
        if (clock != null) clockProvider.overrideWithValue(clock!),
      ],
      child: const GymScaffold(),
    );
  }
}

class GymScaffold extends ConsumerStatefulWidget {
  const GymScaffold({super.key});

  @override
  ConsumerState<GymScaffold> createState() => _GymScaffoldState();
}

class _GymScaffoldState extends ConsumerState<GymScaffold> {
  static const _seed = Color(0xFF1565C0);

  late final ThemeModeController _themeMode;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _themeMode = ref.read(themeModeControllerProvider);
    _router = createRouter(_themeMode);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeMode,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Gym',
          locale: const Locale('en'),
          themeMode: _themeMode.mode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: _seed),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: _seed,
              brightness: Brightness.dark,
            ),
          ),
          routerConfig: _router,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
