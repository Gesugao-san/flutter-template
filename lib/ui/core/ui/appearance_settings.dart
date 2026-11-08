/// Theme and language selectors shared by the welcome and settings screens.
library;

import 'package:flutter/material.dart';

import '../../../domain/models/app_settings.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'segmented_setting.dart';

/// Icons for each [ThemeMode] option.
const Map<ThemeMode, IconData> _themeIcons = {
  ThemeMode.system: Icons.brightness_auto,
  ThemeMode.light: Icons.light_mode,
  ThemeMode.dark: Icons.dark_mode,
};

/// Labeled theme and language selectors.
///
/// A plain widget: it shows [themeMode] and [language] and reports user
/// choices through the callbacks; the owning view model does the rest.
class AppearanceSettings extends StatelessWidget {
  /// Creates the selectors.
  const AppearanceSettings({
    super.key,
    required this.themeMode,
    required this.language,
    required this.onThemeModeChanged,
    required this.onLanguageChanged,
  });

  /// Selected theme mode.
  final ThemeMode themeMode;

  /// Selected language.
  final AppLanguage language;

  /// Called when the user picks a theme mode.
  final ValueChanged<ThemeMode> onThemeModeChanged;

  /// Called when the user picks a language.
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeLabels = {
      ThemeMode.system: l10n.themeSystem,
      ThemeMode.light: l10n.themeLight,
      ThemeMode.dark: l10n.themeDark,
    };
    // Language names are shown in their own language, as is customary.
    final languageLabels = {
      AppLanguage.system: l10n.languageSystem,
      AppLanguage.english: 'English',
      AppLanguage.russian: 'Русский',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledSetting(
          label: l10n.themeLabel,
          child: SegmentedSetting<ThemeMode>(
            options: [
              for (final MapEntry(key: mode, value: label)
                  in themeLabels.entries)
                SegmentOption(
                  value: mode,
                  label: label,
                  icon: _themeIcons[mode],
                ),
            ],
            selected: themeMode,
            onChanged: onThemeModeChanged,
          ),
        ),
        const SizedBox(height: 16),
        LabeledSetting(
          label: l10n.languageLabel,
          child: SegmentedSetting<AppLanguage>(
            options: [
              for (final MapEntry(key: value, value: label)
                  in languageLabels.entries)
                SegmentOption(value: value, label: label),
            ],
            selected: language,
            onChanged: onLanguageChanged,
          ),
        ),
      ],
    );
  }
}
