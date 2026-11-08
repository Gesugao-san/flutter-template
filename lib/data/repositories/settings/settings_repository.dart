/// Contract of the settings repository.
library;

import 'package:flutter/material.dart';

import '../../../domain/models/app_settings.dart';
import '../../../utils/result.dart';

/// Single source of truth for [AppSettings].
///
/// Notifies listeners whenever [settings] change, so the app root (theme,
/// language) and the router (first-run redirect) react immediately.
/// Implementations: `SettingsRepositoryLocal` (device storage) and the fake
/// in `testing/`.
abstract class SettingsRepository extends ChangeNotifier {
  /// Current settings snapshot.
  AppSettings get settings;

  /// Switches the theme to [mode].
  Future<Result<void>> setThemeMode(ThemeMode mode);

  /// Switches the UI language to [language].
  Future<Result<void>> setLanguage(AppLanguage language);

  /// Marks the first-run welcome screen as finished (or not, to show it
  /// again).
  Future<Result<void>> setOnboardingCompleted(bool completed);
}
