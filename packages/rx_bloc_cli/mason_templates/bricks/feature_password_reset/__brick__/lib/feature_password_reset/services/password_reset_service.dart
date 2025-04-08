{{> licence.dart }}

import '../../base/repositories/password_reset_repository.dart';

class PasswordResetService {
  PasswordResetService(this._passwordResetRepository);

  final PasswordResetRepository _passwordResetRepository;

  /// Resets the user's password
  Future<void> resetPassword({
    required String token,
    required String password,
  }) => _passwordResetRepository.resetPassword(token, password);
}
