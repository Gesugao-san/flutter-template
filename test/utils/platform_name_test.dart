/// Unit tests for platform name detection.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_template/utils/platform_name.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns the OS name for native builds', () {
    expect(
      currentPlatformName(isWeb: false, platform: TargetPlatform.android),
      'Android',
    );
  });

  test('prefixes the OS name with Web in browsers', () {
    expect(
      currentPlatformName(isWeb: true, platform: TargetPlatform.windows),
      'Web (Windows)',
    );
  });
}
