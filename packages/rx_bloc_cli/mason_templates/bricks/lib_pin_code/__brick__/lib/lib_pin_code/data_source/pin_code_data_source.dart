{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';

class PinCodeDataSource {
  PinCodeDataSource(
    this._sharedPreferences,
    this._storage,
  );

  final SharedPreferencesInstance _sharedPreferences;
  final FlutterSecureStorage _storage;
  static const _storedPin = 'storedPin';

  Future<String?> checkIsPinCreated() async =>
      await readPinFromStorage(key: _storedPin);

  Future<String> encryptPinCode(String pinCode) async {
    return pinCode;
  }

  Future<int> getPinLength() async => 3;

  Future<bool> setBoolValue(String key, bool value) async =>
      await _sharedPreferences.setBool(key, value);

  Future<bool?> getBoolValue(String key) async =>
      await _sharedPreferences.getBool(key);

  Future<void> writePinToStorage({
    required String key,
    required String? value,
  }) async =>
      await _storage.write(key: key, value: value);

  Future<String?> readPinFromStorage({required String key}) async =>
      await _storage.read(key: key);

  Future<bool> removeBoolValue(String key) async =>
      await _sharedPreferences.remove(key);

  Future<String?> getPinCode() async =>
      await readPinFromStorage(key: _storedPin);
}
