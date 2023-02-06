{{> licence.dart }}

import '../repositories/auth_repository.dart';

class AuthService {
  AuthService(this._authRepository);

  final AuthRepository _authRepository;

  Future<bool> isAuthenticated() async => _authRepository.isAuthenticated();
}
