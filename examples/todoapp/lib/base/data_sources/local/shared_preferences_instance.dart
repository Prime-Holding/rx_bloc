// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// This class is using as wrapper of SharedPreferences to avoid async
/// instance in todo_with_dependencies.dart
class SharedPreferencesInstance {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  Future<String?> getString(String key) async =>
      (await _instance).getString(key);

  Future<bool> setString(String key, String value) async =>
      (await _instance).setString(key, value);

  Future<bool> remove(String key) async => (await _instance).remove(key);

  Future<bool> clear() async => (await _instance).clear();

  Future<bool?> getBool(String key) async => (await _instance).getBool(key);

  Future<bool> setBool(String key, bool value) async =>
      (await _instance).setBool(key, value);
}
