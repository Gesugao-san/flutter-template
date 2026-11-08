/// Tests for the settings screen and its view model.
library;

import 'package:flutter/material.dart';
import 'package:flutter_template/domain/models/app_settings.dart';
import 'package:flutter_template/routing/routes.dart';
import 'package:flutter_template/ui/settings/view_models/settings_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/repositories/fake_settings_repository.dart';

/// Settings of a user who has already finished the welcome screen.
const _onboarded = AppSettings(
  language: AppLanguage.english,
  onboardingCompleted: true,
);

/// Opens the settings screen directly through the router.
Future<void> _openSettings(WidgetTester tester) async {
  final context = tester.element(find.byType(Scaffold).first);
  GoRouter.of(context).push(Routes.settings);
  await tester.pumpAndSettle();
}

void main() {
  test('SettingsViewModel resets the welcome flag', () async {
    final repository = FakeSettingsRepository(_onboarded);
    final viewModel = SettingsViewModel(settingsRepository: repository);

    await viewModel.showWelcomeAgain.execute();

    expect(repository.settings.onboardingCompleted, isFalse);
  });

  testWidgets('switches the theme to dark', (tester) async {
    final repository = FakeSettingsRepository(_onboarded);
    await pumpApp(tester, settingsRepository: repository);
    await _openSettings(tester);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(repository.settings.themeMode, ThemeMode.dark);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });

  testWidgets('can show the welcome screen again', (tester) async {
    await pumpApp(
      tester,
      settingsRepository: FakeSettingsRepository(_onboarded),
    );
    await _openSettings(tester);

    await tester.tap(find.text('Show welcome screen again'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
  });
}
