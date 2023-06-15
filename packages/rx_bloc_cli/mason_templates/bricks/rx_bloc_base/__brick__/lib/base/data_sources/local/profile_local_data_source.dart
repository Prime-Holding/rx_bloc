{{> licence.dart }}

import 'shared_preferences_instance.dart';

/// This class is used to save user profile related settings into shared preferences
/// Currently only notification settings are saved
class ProfileLocalDataSource {
  ProfileLocalDataSource(this._sharedPreferences);
  static const _notificationsSubscribed = 'notificationsSubscribed';
  
  final SharedPreferencesInstance _sharedPreferences;

  Future<bool> notificationsSubscribed() async =>
      await _sharedPreferences.getBool(_notificationsSubscribed) ?? false;

  Future<void> setNotificationsSubscribed(bool subscribed) =>
      _sharedPreferences.setBool(_notificationsSubscribed, subscribed);
}
