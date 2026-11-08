/// Tests for the home screen and its menu.
library;

import 'package:flutter/material.dart';
import 'package:flutter_template/domain/models/app_settings.dart';
import 'package:flutter_template/ui/home/view_models/home_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/repositories/fake_settings_repository.dart';

/// Settings of a user who has already finished the welcome screen.
const _onboarded = AppSettings(
  language: AppLanguage.english,
  onboardingCompleted: true,
);

void main() {
  test('HomeViewModel uses the given platform name', () {
    expect(HomeViewModel(platformName: 'Linux').platformName, 'Linux');
  });

  testWidgets('shows the greeting in the chosen language', (tester) async {
    await pumpApp(
      tester,
      settingsRepository: FakeSettingsRepository(
        _onboarded.copyWith(language: AppLanguage.russian),
      ),
    );

    expect(find.text('Привет, мир!'), findsOneWidget);
  });

  testWidgets('menu opens the settings screen', (tester) async {
    await pumpApp(
      tester,
      settingsRepository: FakeSettingsRepository(_onboarded),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Theme'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
  });

  testWidgets('menu opens the About dialog', (tester) async {
    await pumpApp(
      tester,
      settingsRepository: FakeSettingsRepository(_onboarded),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutDialog), findsOneWidget);
  });
}
