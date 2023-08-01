{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';

class PinCodeDataSource {
  PinCodeDataSource(
    this._storage,
  );

  final FlutterSecureStorage _storage;
  static const _storedPin = 'storedPin';

  Future<int> getPinLength() async => 3;

  Future<void> writePinToStorage({
    required String key,
    required String? value,
  }) async =>
      await _storage.write(key: key, value: value);

  Future<String?> readPinFromStorage({required String key}) async =>
      await _storage.read(key: key);

  Future<String?> getPinCode() async =>
      await readPinFromStorage(key: _storedPin);
}
