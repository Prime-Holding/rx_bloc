{{> licence.dart }}
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';

import '../data_source/pin_biometrics_local_data_source.dart';

class PinBiometricsRepository {
  PinBiometricsRepository(this._pinBiometricsLocalDataSource);

  final BiometricsLocalDataSource _pinBiometricsLocalDataSource;

  Future<bool> areBiometricsEnabled() =>
      (_pinBiometricsLocalDataSource as PinBiometricsLocalDataSource)
          .areBiometricsEnabled();

  Future<void> setBiometricsEnabled(bool enable) =>
      (_pinBiometricsLocalDataSource as PinBiometricsLocalDataSource)
          .setBiometricsEnabled(enable);
}
