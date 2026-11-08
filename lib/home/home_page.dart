/// Home screen: the localized greeting plus theme and language settings.
library;

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../platform/platform_name.dart';
import '../settings/app_settings.dart';

/// Maximum content width, so text and controls stay readable on wide
/// desktop and web windows.
const double _maxContentWidth = 560;

/// The first screen of the application.
class HomePage extends StatelessWidget {
  /// Creates the home page.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_Greeting(), SizedBox(height: 32), _SettingsCard()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The "Hello, World!" headline with the current platform below it.
class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          l10n.helloWorld,
          style: textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.runningOn(currentPlatformName()),
          style: textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Card that groups the theme and language selectors.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.settingsTitle, style: textTheme.titleLarge),
            const SizedBox(height: 16),
            _LabeledSetting(
              label: l10n.themeLabel,
              child: const _ThemeSelector(),
            ),
            const SizedBox(height: 16),
            _LabeledSetting(
              label: l10n.languageLabel,
              child: const _LanguageSelector(),
            ),
          ],
        ),
      ),
    );
  }
}

/// A setting control with a caption above it.
class _LabeledSetting extends StatelessWidget {
  const _LabeledSetting({required this.label, required this.child});

  /// Caption shown above [child].
  final String label;

  /// The control itself.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: child),
      ],
    );
  }
}

/// Compact segment padding so localized labels fit on narrow phones.
const ButtonStyle _segmentStyle = ButtonStyle(
  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
);

/// Builds a single-line segment label that fades out instead of wrapping
/// when space runs out on very narrow screens.
Widget _segmentLabel(String text) =>
    Text(text, maxLines: 1, softWrap: false, overflow: TextOverflow.fade);

/// Icons for each [ThemeMode] option.
const Map<ThemeMode, IconData> _themeIcons = {
  ThemeMode.system: Icons.brightness_auto,
  ThemeMode.light: Icons.light_mode,
  ThemeMode.dark: Icons.dark_mode,
};

/// Segmented control that switches between system, light and dark themes.
class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = AppSettingsScope.of(context);
    final labels = {
      ThemeMode.system: l10n.themeSystem,
      ThemeMode.light: l10n.themeLight,
      ThemeMode.dark: l10n.themeDark,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        // Icons are dropped on narrow screens so long labels fit on one line.
        final showIcons = constraints.maxWidth >= _iconsMinWidth;

        return SegmentedButton<ThemeMode>(
          style: _segmentStyle,
          showSelectedIcon: false,
          segments: [
            for (final MapEntry(key: mode, value: label) in labels.entries)
              ButtonSegment(
                value: mode,
                label: _segmentLabel(label),
                icon: showIcons ? Icon(_themeIcons[mode]) : null,
              ),
          ],
          selected: {settings.themeMode},
          onSelectionChanged: (selection) =>
              settings.setThemeMode(selection.first),
        );
      },
    );
  }

  /// Minimum selector width at which segment icons are shown.
  static const double _iconsMinWidth = 400;
}

/// Language options offered in the UI.
enum _Language { system, english, russian }

/// Locale for each [_Language]; `null` means "follow the system".
const Map<_Language, Locale?> _languageLocales = {
  _Language.system: null,
  _Language.english: Locale('en'),
  _Language.russian: Locale('ru'),
};

/// Segmented control that forces a UI language or follows the system.
class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = AppSettingsScope.of(context);
    // Language names are shown in their own language, as is customary.
    final labels = {
      _Language.system: l10n.languageSystem,
      _Language.english: 'English',
      _Language.russian: 'Русский',
    };

    return SegmentedButton<_Language>(
      style: _segmentStyle,
      showSelectedIcon: false,
      segments: [
        for (final MapEntry(key: language, value: label) in labels.entries)
          ButtonSegment(value: language, label: _segmentLabel(label)),
      ],
      selected: {_languageOf(settings.locale)},
      onSelectionChanged: (selection) =>
          settings.setLocale(_languageLocales[selection.first]),
    );
  }

  /// Maps a forced [locale] back to its [_Language] option.
  static _Language _languageOf(Locale? locale) {
    for (final MapEntry(key: language, value: candidate)
        in _languageLocales.entries) {
      if (candidate == locale) return language;
    }

    return _Language.system;
  }
}
