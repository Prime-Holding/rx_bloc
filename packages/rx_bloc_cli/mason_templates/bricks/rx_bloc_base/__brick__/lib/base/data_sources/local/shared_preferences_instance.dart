// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// This class is using as wrapper of SharedPreferences to avoid async
/// instance in app_dependencies.dart
class SharedPreferencesInstance {
  SharedPreferencesInstance() {
    _instantiate();
  }

  late SharedPreferences data;

  Future<void> _instantiate() async =>
      data = await SharedPreferences.getInstance();

  String? getString(String key) => data.getString(key);

  Future<bool> setString(String key, String value) =>
      data.setString(key, value);

  Future<bool> clear() => data.clear();
}
