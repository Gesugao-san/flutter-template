/// In-memory stand-in for [SettingsRepository].
library;

import 'package:flutter/material.dart';
import 'package:flutter_template/data/repositories/settings/settings_repository.dart';
import 'package:flutter_template/domain/models/app_settings.dart';
import 'package:flutter_template/utils/result.dart';

/// [SettingsRepository] that keeps settings in memory.
///
/// Set [failWrites] to make every change return a [Failure].
class FakeSettingsRepository extends SettingsRepository {
  /// Creates the fake starting from [initial] settings.
  FakeSettingsRepository([AppSettings initial = const AppSettings()])
    : _settings = initial;

  AppSettings _settings;

  /// When `true`, changes fail and [settings] stays the same.
  bool failWrites = false;

  @override
  AppSettings get settings => _settings;

  @override
  Future<Result<void>> setThemeMode(ThemeMode mode) async =>
      _apply(_settings.copyWith(themeMode: mode));

  @override
  Future<Result<void>> setLanguage(AppLanguage language) async =>
      _apply(_settings.copyWith(language: language));

  @override
  Future<Result<void>> setOnboardingCompleted(bool completed) async =>
      _apply(_settings.copyWith(onboardingCompleted: completed));

  Result<void> _apply(AppSettings updated) {
    if (failWrites) return Result.failure(Exception('Write failed'));

    _settings = updated;
    notifyListeners();
    return const Result.ok(null);
  }
}
