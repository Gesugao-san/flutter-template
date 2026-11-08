/// View model of the settings screen.
library;

import 'package:flutter/material.dart';

import '../../../data/repositories/settings/settings_repository.dart';
import '../../../domain/models/app_settings.dart';
import '../../../utils/command.dart';

/// State and actions of the settings screen.
class SettingsViewModel extends ChangeNotifier {
  /// Creates the view model on top of [settingsRepository].
  SettingsViewModel({required this._settingsRepository}) {
    _settingsRepository.addListener(notifyListeners);
    setThemeMode = Command1(_settingsRepository.setThemeMode);
    setLanguage = Command1(_settingsRepository.setLanguage);
    showWelcomeAgain = Command0(
      () => _settingsRepository.setOnboardingCompleted(false),
    );
  }

  final SettingsRepository _settingsRepository;

  /// Selects a theme mode.
  late final Command1<void, ThemeMode> setThemeMode;

  /// Selects a UI language.
  late final Command1<void, AppLanguage> setLanguage;

  /// Resets the first-run flag; the router then opens the welcome screen.
  late final Command0<void> showWelcomeAgain;

  /// Currently selected theme mode.
  ThemeMode get themeMode => _settingsRepository.settings.themeMode;

  /// Currently selected language.
  AppLanguage get language => _settingsRepository.settings.language;

  @override
  void dispose() {
    _settingsRepository.removeListener(notifyListeners);
    setThemeMode.dispose();
    setLanguage.dispose();
    showWelcomeAgain.dispose();
    super.dispose();
  }
}
