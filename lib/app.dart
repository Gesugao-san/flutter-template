/// Root widget that wires theme, localization and settings together.
library;

import 'package:flutter/material.dart';

import 'home/home_page.dart';
import 'l10n/generated/app_localizations.dart';
import 'settings/app_settings.dart';
import 'theme/app_theme.dart';

/// The application root.
///
/// Rebuilds [MaterialApp] whenever [settings] change, so theme and
/// language switches apply instantly across the whole app.
class App extends StatelessWidget {
  /// Creates the application root bound to [settings].
  const App({super.key, required this.settings});

  /// User settings that drive the theme mode and locale.
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      settings: settings,
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.themeMode,
          locale: settings.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );
  }
}
