/// Human-readable name of the platform the app is running on.
library;

import 'package:flutter/foundation.dart';

/// Display names for every [TargetPlatform] value.
const Map<TargetPlatform, String> _platformNames = {
  TargetPlatform.android: 'Android',
  TargetPlatform.iOS: 'iOS',
  TargetPlatform.windows: 'Windows',
  TargetPlatform.macOS: 'macOS',
  TargetPlatform.linux: 'Linux',
  TargetPlatform.fuchsia: 'Fuchsia',
};

/// Returns a display name such as `Android` or `Web (Windows)`.
///
/// On the web [defaultTargetPlatform] reflects the browser's operating
/// system, so the result is prefixed with `Web`. Pass [isWeb] and
/// [platform] explicitly to override detection (useful in tests).
String currentPlatformName({bool isWeb = kIsWeb, TargetPlatform? platform}) {
  final os = _platformNames[platform ?? defaultTargetPlatform] ?? 'Unknown';
  if (isWeb) return 'Web ($os)';

  return os;
}
