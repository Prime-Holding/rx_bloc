{{> licence.dart }}

import '../../base/repositories/password_reset_repository.dart';

class PasswordResetRequestService {
  PasswordResetRequestService(this._passwordResetRepository);

  final PasswordResetRepository _passwordResetRepository;

  Future<String> requestPasswordReset({required String email}) async {
    await _passwordResetRepository.requestPasswordReset(email);
    return email;
  }
}
