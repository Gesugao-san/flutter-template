/// Helpers for widget tests of the whole app.
library;

import 'package:flutter_template/data/repositories/settings/settings_repository.dart';
import 'package:flutter_template/ui/app/widgets/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Pumps the full app (router, themes, localization) on top of
/// [settingsRepository] and waits until it settles.
Future<void> pumpApp(
  WidgetTester tester, {
  required SettingsRepository settingsRepository,
}) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<SettingsRepository>.value(
      value: settingsRepository,
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}
