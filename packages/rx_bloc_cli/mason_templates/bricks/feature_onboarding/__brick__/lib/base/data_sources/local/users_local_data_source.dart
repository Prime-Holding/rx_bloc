{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// This class is used to save user profile to Secure Storage
class UsersLocalDataSource {
  static const _isProfileTemporary = 'isProfileTemporary';

  UsersLocalDataSource(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  Future<bool> isProfileTemporary() async =>
      await _secureStorage.read(key: _isProfileTemporary) == 'true';

  Future<void> setIsProfileTemporary(bool isProfileTemporary) =>
      _secureStorage.write(
        key: _isProfileTemporary,
        value: isProfileTemporary.toString(),
      );

  Future<void> clearIsProfileTemporary() =>
      _secureStorage.delete(key: _isProfileTemporary);
}
