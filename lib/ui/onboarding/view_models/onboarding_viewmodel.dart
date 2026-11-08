/// View model of the first-run welcome screen.
library;

import 'package:flutter/material.dart';

import '../../../data/repositories/settings/settings_repository.dart';
import '../../../domain/models/app_settings.dart';
import '../../../utils/command.dart';

/// State and actions of the welcome screen.
///
/// Choices apply instantly, so the user sees the result before continuing.
/// [finish] marks onboarding as done; the router then leaves the screen by
/// itself.
class OnboardingViewModel extends ChangeNotifier {
  /// Creates the view model on top of [settingsRepository].
  OnboardingViewModel({required this._settingsRepository}) {
    _settingsRepository.addListener(notifyListeners);
    setThemeMode = Command1(_settingsRepository.setThemeMode);
    setLanguage = Command1(_settingsRepository.setLanguage);
    finish = Command0(() => _settingsRepository.setOnboardingCompleted(true));
  }

  final SettingsRepository _settingsRepository;

  /// Selects a theme mode.
  late final Command1<void, ThemeMode> setThemeMode;

  /// Selects a UI language.
  late final Command1<void, AppLanguage> setLanguage;

  /// Completes the welcome flow.
  late final Command0<void> finish;

  /// Currently selected theme mode.
  ThemeMode get themeMode => _settingsRepository.settings.themeMode;

  /// Currently selected language.
  AppLanguage get language => _settingsRepository.settings.language;

  @override
  void dispose() {
    _settingsRepository.removeListener(notifyListeners);
    setThemeMode.dispose();
    setLanguage.dispose();
    finish.dispose();
    super.dispose();
  }
}
