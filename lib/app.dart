import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/data/database.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/locale_controller.dart';
import 'package:gym_app/providers.dart';
import 'package:gym_app/router.dart';
import 'package:gym_app/theme_mode_controller.dart';

class GymApp extends StatelessWidget {
  const GymApp({
    super.key,
    this.themeMode,
    this.locale,
    this.database,
    this.clock,
  });

  final ThemeModeController? themeMode;
  final LocaleController? locale;
  final AppDatabase? database;
  final DateTime Function()? clock;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        if (themeMode != null)
          themeModeControllerProvider.overrideWithValue(themeMode!),
        if (locale != null) localeControllerProvider.overrideWithValue(locale!),
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

class _GymScaffoldState extends ConsumerState<GymScaffold>
    with WidgetsBindingObserver {
  static const _seed = Color(0xFF1565C0);

  late final ThemeModeController _themeMode;
  late final LocaleController _locale;
  late final GoRouter _router;
  late Locale _platform;

  @override
  void initState() {
    super.initState();
    _themeMode = ref.read(themeModeControllerProvider);
    _locale = ref.read(localeControllerProvider);
    _router = createRouter(_themeMode, _locale);
    _platform = WidgetsBinding.instance.platformDispatcher.locale;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router.dispose();
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    final next = locales != null && locales.isNotEmpty
        ? locales.first
        : WidgetsBinding.instance.platformDispatcher.locale;
    if (next == _platform) {
      return;
    }
    setState(() => _platform = next);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_themeMode, _locale]),
      builder: (context, _) {
        final locale = _locale.resolve(_platform);
        return MaterialApp.router(
          onGenerateTitle: (context) => AppStrings(locale).text('Gym'),
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('es')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
            return AppStringsScope(
              strings: AppStrings(Localizations.localeOf(context)),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}
