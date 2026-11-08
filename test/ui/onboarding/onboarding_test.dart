/// Tests for the first-run welcome screen and its view model.
library;

import 'package:flutter/material.dart';
import 'package:flutter_template/domain/models/app_settings.dart';
import 'package:flutter_template/ui/onboarding/view_models/onboarding_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../testing/app.dart';
import '../../../testing/fakes/repositories/fake_settings_repository.dart';

void main() {
  group('OnboardingViewModel', () {
    test('finish marks onboarding as completed', () async {
      final repository = FakeSettingsRepository();
      final viewModel = OnboardingViewModel(settingsRepository: repository);

      await viewModel.finish.execute();

      expect(repository.settings.onboardingCompleted, isTrue);
    });

    test('exposes the repository choices', () async {
      final repository = FakeSettingsRepository();
      final viewModel = OnboardingViewModel(settingsRepository: repository);

      await viewModel.setThemeMode.execute(ThemeMode.dark);
      await viewModel.setLanguage.execute(AppLanguage.russian);

      expect(viewModel.themeMode, ThemeMode.dark);
      expect(viewModel.language, AppLanguage.russian);
    });
  });

  group('OnboardingScreen', () {
    testWidgets('is shown on first launch', (tester) async {
      await pumpApp(
        tester,
        settingsRepository: FakeSettingsRepository(
          const AppSettings(language: AppLanguage.english),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Hello, World!'), findsNothing);
    });

    testWidgets('applies the language instantly', (tester) async {
      await pumpApp(
        tester,
        settingsRepository: FakeSettingsRepository(
          const AppSettings(language: AppLanguage.english),
        ),
      );

      await tester.tap(find.text('Русский'));
      await tester.pumpAndSettle();

      expect(find.text('Добро пожаловать'), findsOneWidget);
    });

    testWidgets('Get started opens the home screen', (tester) async {
      final repository = FakeSettingsRepository(
        const AppSettings(language: AppLanguage.english),
      );
      await pumpApp(tester, settingsRepository: repository);

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();

      expect(repository.settings.onboardingCompleted, isTrue);
      expect(find.text('Hello, World!'), findsOneWidget);
    });

    testWidgets('shows an error when saving fails', (tester) async {
      final repository = FakeSettingsRepository(
        const AppSettings(language: AppLanguage.english),
      )..failWrites = true;
      await pumpApp(tester, settingsRepository: repository);

      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't save settings. Try again."), findsOneWidget);
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
