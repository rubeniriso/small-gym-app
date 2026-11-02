import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/app.dart';
import 'package:gym_app/theme_mode_controller.dart';

void main() {
  testWidgets('Home is empty and the drawer opens Routines from the left', (
    tester,
  ) async {
    await tester.pumpWidget(const GymApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('No current routine.'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('No current routine.'))).useMaterial3,
      isTrue,
    );

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsOneWidget);
    expect(tester.getRect(find.byType(Drawer)).left, 0);
    expect(
      Directionality.of(tester.element(find.byType(Drawer))),
      TextDirection.ltr,
    );

    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();

    expect(find.text('Routines'), findsOneWidget);
    expect(find.text('No routines yet.'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('No current routine.'), findsOneWidget);

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Routines'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('No current routine.'), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
  });

  testWidgets('theme follows the system until the switch overrides it', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    final themeMode = ThemeModeController();
    await tester.pumpWidget(GymApp(themeMode: themeMode));
    await tester.pumpAndSettle();

    Brightness brightness() {
      return Theme.of(tester.element(find.text('No current routine.')))
          .brightness;
    }

    expect(themeMode.mode, ThemeMode.system);
    expect(brightness(), Brightness.dark);

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    expect(themeMode.mode, ThemeMode.light);
    expect(brightness(), Brightness.light);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(themeMode.mode, ThemeMode.dark);
    expect(brightness(), Brightness.dark);

    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();

    expect(themeMode.mode, ThemeMode.system);
    expect(brightness(), Brightness.dark);
  });
}
