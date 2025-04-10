{{> licence.dart }}

import '../repository/pin_biometrics_repository.dart';

class PinBiometricsService {
  PinBiometricsService(this._pinBiometricsRepository);

  final PinBiometricsRepository _pinBiometricsRepository;

  Future<bool> areBiometricsEnabled() =>
      _pinBiometricsRepository.areBiometricsEnabled();

  Future<void> setBiometricsEnabled(bool enable) =>
      _pinBiometricsRepository.setBiometricsEnabled(enable);
}
