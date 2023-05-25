{{> licence.dart }}

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// This class is using as wrapper of SharedPreferences to avoid async
/// instance in {{project_name}}_with_dependencies.dart
class SharedPreferencesInstance {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  Future<String?> getString(String key) async =>
      (await _instance).getString(key);

  Future<bool> setString(String key, String value) async =>
      (await _instance).setString(key, value);{{#enable_pin_code}}

  Future<bool?> getBool(String key) async =>
      (await _instance).getBool(key);

  Future<bool> setBool(String key, bool value) async =>
      (await _instance).setBool(key, value);{{/enable_pin_code}}

  Future<bool> remove(String key) async => (await _instance).remove(key);

  Future<bool> clear() async => (await _instance).clear();
}
