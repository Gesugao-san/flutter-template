/// Settings repository backed by device storage.
library;

import 'package:flutter/material.dart';

import '../../../domain/models/app_settings.dart';
import '../../../utils/result.dart';
import '../../services/shared_preferences_service.dart';
import 'settings_repository.dart';

/// [SettingsRepository] that persists settings with
/// [SharedPreferencesService].
///
/// The current snapshot is read synchronously on construction, so the first
/// frame already uses the saved theme and language.
class SettingsRepositoryLocal extends SettingsRepository {
  /// Creates the repository and loads saved settings from [service].
  SettingsRepositoryLocal({required this._service}) {
    _settings = _load();
  }

  static const String _themeModeKey = 'settings.theme_mode';
  static const String _languageKey = 'settings.language';
  static const String _onboardingCompletedKey = 'settings.onboarding_completed';

  /// Storage keys this repository uses; pass them to
  /// [SharedPreferencesService.create].
  static const Set<String> storageKeys = {
    _themeModeKey,
    _languageKey,
    _onboardingCompletedKey,
  };

  final SharedPreferencesService _service;
  late AppSettings _settings;

  @override
  AppSettings get settings => _settings;

  @override
  Future<Result<void>> setThemeMode(ThemeMode mode) {
    return _save(
      _settings.copyWith(themeMode: mode),
      () => _service.setString(_themeModeKey, mode.name),
    );
  }

  @override
  Future<Result<void>> setLanguage(AppLanguage language) {
    return _save(
      _settings.copyWith(language: language),
      () => _service.setString(_languageKey, language.name),
    );
  }

  @override
  Future<Result<void>> setOnboardingCompleted(bool completed) {
    return _save(
      _settings.copyWith(onboardingCompleted: completed),
      () => _service.setBool(_onboardingCompletedKey, completed),
    );
  }

  /// Reads saved values; unknown or missing ones fall back to defaults.
  AppSettings _load() {
    const defaults = AppSettings();
    final themeMode = ThemeMode.values
        .asNameMap()[_service.getString(_themeModeKey)];
    final language = AppLanguage.values
        .asNameMap()[_service.getString(_languageKey)];

    return AppSettings(
      themeMode: themeMode ?? defaults.themeMode,
      language: language ?? defaults.language,
      onboardingCompleted:
          _service.getBool(_onboardingCompletedKey) ??
          defaults.onboardingCompleted,
    );
  }

  /// Persists a change with [write] and, on success, publishes [updated].
  ///
  /// Does nothing when [updated] equals the current snapshot; keeps the
  /// current snapshot when the write fails.
  Future<Result<void>> _save(
    AppSettings updated,
    Future<Result<void>> Function() write,
  ) async {
    if (updated == _settings) return const Result.ok(null);

    final result = await write();
    if (result is Failure<void>) return result;

    _settings = updated;
    notifyListeners();
    return result;
  }
}
