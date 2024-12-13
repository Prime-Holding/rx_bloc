{{> licence.dart }}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Data source used to save user profile to Secure Storage
class UsersLocalDataSource {
  /// Key used to store if the profile is temporary
  static const _isProfileTemporary = 'isProfileTemporary';

  UsersLocalDataSource(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  /// Returns true if the profile is temporary, during onboarding
  Future<bool> isProfileTemporary() async =>
      await _secureStorage.read(key: _isProfileTemporary) == 'true';

  /// Sets the profile as temporary, during onboarding
  Future<void> setIsProfileTemporary(bool isProfileTemporary) =>
      _secureStorage.write(
        key: _isProfileTemporary,
        value: isProfileTemporary.toString(),
      );

  /// Clears the temporary profile, after finished onboarding
  Future<void> clearIsProfileTemporary() =>
      _secureStorage.delete(key: _isProfileTemporary);
}
