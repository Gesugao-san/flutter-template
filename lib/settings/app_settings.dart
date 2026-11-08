/// User-selectable runtime settings and their scope in the widget tree.
library;

import 'package:flutter/material.dart';

/// Holds user-selectable settings and notifies listeners on change.
///
/// Settings live in memory only. Persist them (for example with the
/// `shared_preferences` package) when a real project needs it.
class AppSettings extends ChangeNotifier {
  /// Creates settings; both values follow the operating system by default.
  ///
  /// The private fields are initialized from public named parameters
  /// `themeMode` and `locale`.
  AppSettings({this._themeMode = ThemeMode.system, this._locale});

  ThemeMode _themeMode;
  Locale? _locale;

  /// Current theme mode; [ThemeMode.system] follows the operating system.
  ThemeMode get themeMode => _themeMode;

  /// Forced UI locale, or `null` to follow the operating system.
  Locale? get locale => _locale;

  /// Switches the theme to [mode] and notifies listeners if it changed.
  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;

    _themeMode = mode;
    notifyListeners();
  }

  /// Switches the UI language to [locale] (`null` means system) and
  /// notifies listeners if it changed.
  void setLocale(Locale? locale) {
    if (locale == _locale) return;

    _locale = locale;
    notifyListeners();
  }
}

/// Exposes [AppSettings] to descendants and rebuilds them on change.
class AppSettingsScope extends InheritedNotifier<AppSettings> {
  /// Places [settings] above [child] in the widget tree.
  const AppSettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  /// Returns the nearest [AppSettings] and subscribes [context] to changes.
  ///
  /// Throws a [FlutterError] when there is no [AppSettingsScope] ancestor.
  static AppSettings of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    if (scope == null) {
      throw FlutterError(
        'AppSettingsScope.of() was called without an AppSettingsScope '
        'ancestor.',
      );
    }

    return scope.notifier!;
  }
}
