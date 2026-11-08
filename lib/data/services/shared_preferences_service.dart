/// Thin wrapper over `shared_preferences` used by repositories.
library;

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/result.dart';

/// Key-value storage on the device (preferences on Android/iOS/desktop,
/// `localStorage` on the web).
///
/// Reads are synchronous from an in-memory cache filled at startup; writes
/// are asynchronous and report failures as [Result] instead of throwing.
class SharedPreferencesService {
  /// Wraps already loaded [preferences].
  SharedPreferencesService(this._preferences);

  /// Loads stored values for [keys] and returns a ready service.
  ///
  /// Only keys from [keys] can be read or written, which keeps unrelated
  /// data out of the cache.
  static Future<SharedPreferencesService> create({
    required Set<String> keys,
  }) async {
    final preferences = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(allowList: keys),
    );

    return SharedPreferencesService(preferences);
  }

  final SharedPreferencesWithCache _preferences;

  /// Returns the string stored under [key], or `null` if there is none.
  String? getString(String key) => _preferences.getString(key);

  /// Returns the boolean stored under [key], or `null` if there is none.
  bool? getBool(String key) => _preferences.getBool(key);

  /// Stores [value] under [key].
  Future<Result<void>> setString(String key, String value) =>
      _guard(() => _preferences.setString(key, value));

  /// Stores [value] under [key].
  Future<Result<void>> setBool(String key, bool value) =>
      _guard(() => _preferences.setBool(key, value));

  /// Runs [write] and converts thrown exceptions into a [Failure].
  Future<Result<void>> _guard(Future<void> Function() write) async {
    try {
      await write();
      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.failure(error);
    }
  }
}
