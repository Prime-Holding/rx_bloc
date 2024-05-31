// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'shared_preferences_instance.dart';

/// This class is used to save user profile related settings into shared preferences
/// Currently only notification settings are saved
class ProfileLocalDataSource {
  ProfileLocalDataSource(this._sharedPreferences);
  static const _notificationsSubscribed = 'notificationsSubscribed';
  static const _notificationsEnabled = 'notificationsEnabled';

  final SharedPreferencesInstance _sharedPreferences;

  Future<bool> notificationsSubscribed() async =>
      await _sharedPreferences.getBool(_notificationsSubscribed) ?? false;

  Future<void> setNotificationsSubscribed(bool subscribed) =>
      _sharedPreferences.setBool(_notificationsSubscribed, subscribed);

  Future<bool> notificationsEnabled() async =>
      await _sharedPreferences.getBool(_notificationsEnabled) ?? false;

  Future<void> setNotificationsEnabled(bool enabled) =>
      _sharedPreferences.setBool(_notificationsEnabled, enabled);
}
