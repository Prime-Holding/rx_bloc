{{> licence.dart }}

import 'shared_preferences_instance.dart';

/// This class is used to save user profile related settings into shared preferences
/// Currently only notification settings are saved
class ProfileLocalDataSource {
  static const _notificationsEnabled = 'notificationsEnabled';
  static const _notificationsSubscribed = 'notificationsSubscribed';
  ProfileLocalDataSource(this._sharedPreferences);

  final SharedPreferencesInstance _sharedPreferences;

  Future<bool> notificationsEnabled() async =>
      await _sharedPreferences.getBool(_notificationsEnabled) ?? false;

  Future<void> setNotificationsEnabled(bool enabled) =>
      _sharedPreferences.setBool(_notificationsEnabled, enabled);

  Future<bool> notificationsSubscribed() async =>
      await _sharedPreferences.getBool(_notificationsSubscribed) ?? false;

  Future<void> setNotificationsSubscribed(bool subscribed) =>
      _sharedPreferences.setBool(_notificationsSubscribed, subscribed);
}
