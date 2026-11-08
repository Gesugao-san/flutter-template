/// Flutter Base: a universal cross-platform starter application.
///
/// One code base for Android, iOS, Windows, macOS, Linux and the web.
/// It shows a localized "Hello, World!" screen and demonstrates the
/// building blocks shared by future projects:
///
/// * Material 3 light and dark themes that follow the system by default;
/// * English and Russian localization generated from ARB files;
/// * an adaptive, width-constrained layout that works from phones to
///   desktop windows.
library;

import 'package:flutter/material.dart';

import 'app.dart';
import 'settings/app_settings.dart';

/// Application entry point.
void main() {
  runApp(App(settings: AppSettings()));
}
