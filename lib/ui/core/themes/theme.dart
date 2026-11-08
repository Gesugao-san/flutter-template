/// Material 3 themes shared by every platform.
library;

import 'package:flutter/material.dart';

/// Factory for the light and dark application themes.
///
/// Both themes are generated from one [seedColor], so changing that single
/// value re-brands the whole app consistently.
abstract final class AppTheme {
  /// Brand color the color schemes are derived from.
  static const Color seedColor = Colors.teal;

  /// Theme used in light mode.
  static ThemeData light() => _build(Brightness.light);

  /// Theme used in dark mode.
  static ThemeData dark() => _build(Brightness.dark);

  /// Builds a theme for [brightness] from [seedColor].
  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(colorScheme: colorScheme);
  }
}
