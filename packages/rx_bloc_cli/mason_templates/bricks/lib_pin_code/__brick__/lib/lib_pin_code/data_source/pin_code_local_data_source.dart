{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinCodeLocalDataSource {
  PinCodeLocalDataSource(
    this._storage,
  );

  final FlutterSecureStorage _storage;
  static const _storedPin = 'storedPin';

  Future<int> getPinLength() async => 4;

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
