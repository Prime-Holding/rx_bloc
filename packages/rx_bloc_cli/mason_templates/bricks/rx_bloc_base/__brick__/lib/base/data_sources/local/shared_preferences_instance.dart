{{> licence.dart }}

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// This class is using as wrapper of SharedPreferences to avoid async
/// instance in app_dependencies.dart
class SharedPreferencesInstance {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  Future<String?> getString(String key) async =>
      (await _instance).getString(key);

  Future<bool> setString(String key, String value) async =>
      (await _instance).setString(key, value);

  Future<bool> remove(String key) async => (await _instance).remove(key);

  Future<bool> clear() async => (await _instance).clear();
}
