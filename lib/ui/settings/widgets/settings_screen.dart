/// Settings screen.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/ui/appearance_settings.dart';
import '../../core/ui/command_error_listener.dart';
import '../../core/ui/constrained_page_body.dart';
import '../view_models/settings_viewmodel.dart';

/// Lets the user change appearance and replay the welcome screen.
///
/// Reads [SettingsViewModel] from the context (provided by the router).
class SettingsScreen extends StatelessWidget {
  /// Creates the settings screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: CommandErrorListener(
        commands: [
          viewModel.setThemeMode,
          viewModel.setLanguage,
          viewModel.showWelcomeAgain,
        ],
        message: l10n.saveFailed,
        child: ConstrainedPageBody(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppearanceSettings(
                themeMode: viewModel.themeMode,
                language: viewModel.language,
                onThemeModeChanged: viewModel.setThemeMode.execute,
                onLanguageChanged: viewModel.setLanguage.execute,
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: viewModel.showWelcomeAgain.execute,
                icon: const Icon(Icons.replay),
                label: Text(l10n.showWelcomeAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
