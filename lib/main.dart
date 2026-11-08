/// Flutter Template: a universal cross-platform starter application.
///
/// One code base for Android, iOS, Windows, macOS, Linux and the web,
/// structured after the official Flutter architecture guide
/// (https://docs.flutter.dev/app-architecture):
///
/// * `data/` – services (device storage) and repositories (settings);
/// * `domain/` – immutable models shared by all layers;
/// * `ui/` – one folder per feature with a view and its view model;
/// * `routing/` and `config/` – navigation and dependency injection.
///
/// On first launch a welcome screen asks for theme and language; afterwards
/// the home screen shows a localized "Hello, World!" and settings live in
/// its menu.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'data/repositories/settings/settings_repository_local.dart';
import 'data/services/shared_preferences_service.dart';
import 'ui/app/widgets/app.dart';

/// Application entry point: loads saved settings, then starts the UI.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferencesService.create(
    keys: SettingsRepositoryLocal.storageKeys,
  );

  runApp(
    MultiProvider(
      providers: providersLocal(preferences: preferences),
      child: const App(),
    ),
  );
}
