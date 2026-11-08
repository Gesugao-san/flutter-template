/// View model of the application root.
library;

import 'package:flutter/material.dart';

import '../../../data/repositories/settings/settings_repository.dart';

/// Exposes app-wide presentation state (theme and locale) to [App].
///
/// Re-notifies whenever the settings repository changes.
class AppViewModel extends ChangeNotifier {
  /// Creates the view model and subscribes to [settingsRepository].
  AppViewModel({required this._settingsRepository}) {
    _settingsRepository.addListener(notifyListeners);
  }

  final SettingsRepository _settingsRepository;

  /// Theme mode chosen by the user.
  ThemeMode get themeMode => _settingsRepository.settings.themeMode;

  /// Forced locale, or `null` to follow the system.
  Locale? get locale => _settingsRepository.settings.language.locale;

  @override
  void dispose() {
    _settingsRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
