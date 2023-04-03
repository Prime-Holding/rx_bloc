{{> licence.dart }}

import 'package:shared_preferences/shared_preferences.dart';

class LanguagePickerSharedPreferencesInstance {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  Future<String?> getString(String key) async =>
      (await _instance).getString(key);

  Future<bool> setString(String key, String value) async =>
      (await _instance).setString(key, value);

  Future<bool> remove(String key) async => (await _instance).remove(key);

  Future<bool> clear() async => (await _instance).clear();
}
