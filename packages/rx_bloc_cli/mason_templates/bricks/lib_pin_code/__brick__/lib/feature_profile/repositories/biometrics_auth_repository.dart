import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

class BiometricsAuthRepository {
  final PinBiometricsAuthDataSource _dataSource;

  BiometricsAuthRepository(this._dataSource);

  Future<bool> isBiometricsAuthEnabled() async =>
      (await _dataSource.availableBiometrics).isNotEmpty;
}
