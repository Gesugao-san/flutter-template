/// Home screen: the localized greeting with settings hidden in the menu.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../routing/routes.dart';
import '../../core/ui/constrained_page_body.dart';
import '../view_models/home_viewmodel.dart';

/// Items of the overflow ("⋮") menu.
enum _MenuItem { settings, about }

/// The main screen of the application.
///
/// Reads [HomeViewModel] from the context (provided by the router).
class HomeScreen extends StatelessWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<HomeViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [_OverflowMenu()],
      ),
      body: ConstrainedPageBody(
        child: Column(
          children: [
            Text(
              l10n.helloWorld,
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.runningOn(viewModel.platformName),
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// The "⋮" menu with rarely used entries.
class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = {
      _MenuItem.settings: l10n.settingsTitle,
      _MenuItem.about: l10n.aboutTitle,
    };

    return PopupMenuButton<_MenuItem>(
      onSelected: (item) => _open(context, item),
      itemBuilder: (context) => [
        for (final MapEntry(key: item, value: label) in labels.entries)
          PopupMenuItem(value: item, child: Text(label)),
      ],
    );
  }

  /// Opens the destination of [item].
  void _open(BuildContext context, _MenuItem item) {
    switch (item) {
      case _MenuItem.settings:
        context.push(Routes.settings);
      case _MenuItem.about:
        final l10n = AppLocalizations.of(context);
        showAboutDialog(
          context: context,
          applicationName: l10n.appTitle,
          applicationLegalese: l10n.aboutLegalese,
        );
    }
  }
}
