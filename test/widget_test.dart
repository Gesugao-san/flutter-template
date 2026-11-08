/// Widget and unit tests for the Flutter Base starter.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_base/app.dart';
import 'package:flutter_base/platform/platform_name.dart';
import 'package:flutter_base/settings/app_settings.dart';

/// Pumps the whole app with [settings] and waits for localizations to load.
Future<void> pumpApp(WidgetTester tester, AppSettings settings) async {
  await tester.pumpWidget(App(settings: settings));
  await tester.pumpAndSettle();
}

/// Returns the [MaterialApp] currently in the tree.
MaterialApp materialApp(WidgetTester tester) =>
    tester.widget<MaterialApp>(find.byType(MaterialApp));

void main() {
  group('greeting', () {
    testWidgets('is shown in English', (tester) async {
      await pumpApp(tester, AppSettings(locale: const Locale('en')));

      expect(find.text('Hello, World!'), findsOneWidget);
    });

    testWidgets('is shown in Russian', (tester) async {
      await pumpApp(tester, AppSettings(locale: const Locale('ru')));

      expect(find.text('Привет, мир!'), findsOneWidget);
    });
  });

  group('settings', () {
    testWidgets('theme selector switches to dark mode', (tester) async {
      final settings = AppSettings(locale: const Locale('en'));
      await pumpApp(tester, settings);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(settings.themeMode, ThemeMode.dark);
      expect(materialApp(tester).themeMode, ThemeMode.dark);
    });

    testWidgets('language selector switches to Russian', (tester) async {
      final settings = AppSettings(locale: const Locale('en'));
      await pumpApp(tester, settings);

      await tester.tap(find.text('Русский'));
      await tester.pumpAndSettle();

      expect(settings.locale, const Locale('ru'));
      expect(find.text('Привет, мир!'), findsOneWidget);
    });

    test('notifies listeners only on real changes', () {
      final settings = AppSettings();
      var notifications = 0;
      settings.addListener(() => notifications++);

      settings.setThemeMode(ThemeMode.system);
      settings.setThemeMode(ThemeMode.light);
      settings.setLocale(null);
      settings.setLocale(const Locale('ru'));

      expect(notifications, 2);
    });
  });

  group('currentPlatformName', () {
    test('returns the OS name for native builds', () {
      expect(
        currentPlatformName(isWeb: false, platform: TargetPlatform.android),
        'Android',
      );
    });

    test('prefixes the OS name with Web in browsers', () {
      expect(
        currentPlatformName(isWeb: true, platform: TargetPlatform.windows),
        'Web (Windows)',
      );
    });
  });
}
