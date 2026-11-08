/// View model of the home screen.
library;

import 'package:flutter/foundation.dart';

import '../../../utils/platform_name.dart';

/// State of the home screen.
///
/// The Hello World screen has almost no logic yet; this is the place to add
/// it (data from repositories, commands for user actions) as the app grows.
class HomeViewModel extends ChangeNotifier {
  /// Creates the view model; [platformName] overrides platform detection
  /// (useful in tests).
  HomeViewModel({String? platformName})
    : platformName = platformName ?? currentPlatformName();

  /// Display name of the platform the app runs on.
  final String platformName;
}
