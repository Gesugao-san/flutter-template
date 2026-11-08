/// In-memory stand-in for [SharedPreferencesService].
library;

import 'package:flutter_template/data/services/shared_preferences_service.dart';
import 'package:flutter_template/utils/result.dart';

/// [SharedPreferencesService] that keeps values in a map.
///
/// Set [failWrites] to make every write return a [Failure].
class FakeSharedPreferencesService implements SharedPreferencesService {
  /// Creates the fake with optional [initialValues].
  FakeSharedPreferencesService([Map<String, Object>? initialValues])
    : values = {...?initialValues};

  /// Stored values, exposed for assertions.
  final Map<String, Object> values;

  /// When `true`, writes fail and leave [values] untouched.
  bool failWrites = false;

  @override
  String? getString(String key) => values[key] as String?;

  @override
  bool? getBool(String key) => values[key] as bool?;

  @override
  Future<Result<void>> setString(String key, String value) async =>
      _write(key, value);

  @override
  Future<Result<void>> setBool(String key, bool value) async =>
      _write(key, value);

  Result<void> _write(String key, Object value) {
    if (failWrites) return Result.failure(Exception('Write failed'));

    values[key] = value;
    return const Result.ok(null);
  }
}
