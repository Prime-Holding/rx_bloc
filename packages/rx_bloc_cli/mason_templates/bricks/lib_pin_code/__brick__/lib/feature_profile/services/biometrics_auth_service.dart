import '../repositories/biometrics_auth_repository.dart';

class BiometricsAuthService {
  BiometricsAuthService(this._repository);
  final BiometricsAuthRepository _repository;

  Future<bool> canCheckBiometrics() => _repository.canCheckBiometrics();
}
