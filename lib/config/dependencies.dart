/// Dependency injection setup: which services and repositories the app
/// uses.
library;

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/settings/settings_repository.dart';
import '../data/repositories/settings/settings_repository_local.dart';
import '../data/services/shared_preferences_service.dart';

/// Providers for an app that stores data on the device.
///
/// Services come first, repositories after them, so repositories can read
/// services from the context. To add a backend later, create another list
/// (e.g. `providersRemote`) and pick it in `main.dart`.
List<SingleChildWidget> providersLocal({
  required SharedPreferencesService preferences,
}) {
  return [
    Provider<SharedPreferencesService>.value(value: preferences),
    ChangeNotifierProvider<SettingsRepository>(
      create: (context) => SettingsRepositoryLocal(service: context.read()),
    ),
  ];
}
