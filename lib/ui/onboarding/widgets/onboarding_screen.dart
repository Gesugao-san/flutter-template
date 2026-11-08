/// First-run welcome screen.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/ui/appearance_settings.dart';
import '../../core/ui/command_error_listener.dart';
import '../../core/ui/constrained_page_body.dart';
import '../view_models/onboarding_viewmodel.dart';

/// Welcome screen shown until the user taps "Get started".
///
/// Reads [OnboardingViewModel] from the context (provided by the router).
/// Extend it with more first-run steps as the app requires.
class OnboardingScreen extends StatelessWidget {
  /// Creates the welcome screen.
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<OnboardingViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CommandErrorListener(
        commands: [
          viewModel.setThemeMode,
          viewModel.setLanguage,
          viewModel.finish,
        ],
        message: l10n.saveFailed,
        child: ConstrainedPageBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.welcomeTitle,
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.welcomeBody,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppearanceSettings(
                themeMode: viewModel.themeMode,
                language: viewModel.language,
                onThemeModeChanged: viewModel.setThemeMode.execute,
                onLanguageChanged: viewModel.setLanguage.execute,
              ),
              const SizedBox(height: 32),
              ListenableBuilder(
                listenable: viewModel.finish,
                builder: (context, _) => FilledButton(
                  onPressed: viewModel.finish.running
                      ? null
                      : viewModel.finish.execute,
                  child: Text(l10n.getStarted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
