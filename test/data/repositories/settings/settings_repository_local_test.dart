/// Unit tests for [SettingsRepositoryLocal].
library;

import 'package:flutter/material.dart';
import 'package:flutter_template/data/repositories/settings/settings_repository_local.dart';
import 'package:flutter_template/domain/models/app_settings.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../testing/fakes/services/fake_shared_preferences_service.dart';

void main() {
  late FakeSharedPreferencesService service;

  setUp(() => service = FakeSharedPreferencesService());

  test('starts with defaults when nothing is stored', () {
    final repository = SettingsRepositoryLocal(service: service);

    expect(repository.settings, const AppSettings());
  });

  test('loads previously saved settings', () async {
    final first = SettingsRepositoryLocal(service: service);
    await first.setThemeMode(ThemeMode.dark);
    await first.setLanguage(AppLanguage.russian);
    await first.setOnboardingCompleted(true);

    final second = SettingsRepositoryLocal(service: service);

    expect(
      second.settings,
      const AppSettings(
        themeMode: ThemeMode.dark,
        language: AppLanguage.russian,
        onboardingCompleted: true,
      ),
    );
  });

  test('ignores unknown stored values', () {
    service.values['settings.theme_mode'] = 'purple';

    final repository = SettingsRepositoryLocal(service: service);

    expect(repository.settings.themeMode, ThemeMode.system);
  });

  test('notifies listeners only on real changes', () async {
    final repository = SettingsRepositoryLocal(service: service);
    var notifications = 0;
    repository.addListener(() => notifications++);

    await repository.setThemeMode(ThemeMode.system);
    await repository.setThemeMode(ThemeMode.light);

    expect(notifications, 1);
  });

  test('keeps settings and reports failure when saving fails', () async {
    final repository = SettingsRepositoryLocal(service: service);
    service.failWrites = true;

    final result = await repository.setThemeMode(ThemeMode.dark);

    expect(result, isA<Failure<void>>());
    expect(repository.settings.themeMode, ThemeMode.system);
  });
}
