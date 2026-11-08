/// User preferences shared by the whole app.
library;

import 'package:flutter/material.dart';

/// UI language options; [locale] is `null` for "follow the system".
enum AppLanguage {
  /// Use the operating system language.
  system(null),

  /// Always English.
  english(Locale('en')),

  /// Always Russian.
  russian(Locale('ru'));

  const AppLanguage(this.locale);

  /// Locale forced by this option, or `null` to follow the system.
  final Locale? locale;
}

/// Immutable snapshot of user preferences.
///
/// Changes produce a new instance via [copyWith]; only the settings
/// repository creates updated snapshots (unidirectional data flow).
@immutable
class AppSettings {
  /// Creates settings; defaults follow the system and show the welcome
  /// screen on first launch.
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = AppLanguage.system,
    this.onboardingCompleted = false,
  });

  /// Light, dark or system theme.
  final ThemeMode themeMode;

  /// Forced UI language or [AppLanguage.system].
  final AppLanguage language;

  /// Whether the user has finished the first-run welcome screen.
  final bool onboardingCompleted;

  /// Returns a copy with the given fields replaced.
  AppSettings copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.language == language &&
      other.onboardingCompleted == onboardingCompleted;

  @override
  int get hashCode => Object.hash(themeMode, language, onboardingCompleted);

  @override
  String toString() =>
      'AppSettings(themeMode: $themeMode, language: $language, '
      'onboardingCompleted: $onboardingCompleted)';
}
