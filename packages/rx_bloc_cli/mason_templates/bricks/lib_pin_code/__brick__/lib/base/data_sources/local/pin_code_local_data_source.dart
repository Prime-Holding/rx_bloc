{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinCodeLocalDataSource {
  PinCodeLocalDataSource(
    this._storage,
  );

  final FlutterSecureStorage _storage;
  static const _storedPin = 'storedPin';

  /// Store the encrypted pin code in the secure storage
  Future<void> storePin(String encryptedPin) async =>
      await _storage.write(key: _storedPin, value: encryptedPin);

  /// Get the locally stored encrypted pin code from the secure storage
  Future<String?> getPin() async => await _storage.read(key: _storedPin);
}
