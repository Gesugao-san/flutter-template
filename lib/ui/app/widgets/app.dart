/// Root widget: wires router, themes and localization together.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../routing/router.dart';
import '../../core/themes/theme.dart';
import '../view_models/app_viewmodel.dart';

/// The application root.
///
/// Expects the providers from `config/dependencies.dart` above it. Creates
/// the router and the root view model once and rebuilds [MaterialApp] when
/// the theme or language changes.
class App extends StatefulWidget {
  /// Creates the application root.
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = router(context.read());
  late final AppViewModel _viewModel = AppViewModel(
    settingsRepository: context.read(),
  );

  @override
  void dispose() {
    _viewModel.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) => MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: _viewModel.themeMode,
        locale: _viewModel.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    );
  }
}
