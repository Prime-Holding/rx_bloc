{{> licence.dart }}

import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';

/// You have to implement and provide a [BiometricsLocalDataSource], you can
/// store the value of [_areBiometricsEnabled], for example in [SharedPreferences]
class ProfileLocalDataSource implements BiometricsLocalDataSource {
  ProfileLocalDataSource();

  /// This bool check is intended to be stored in the secured storage for production
  /// applications
  bool? _areBiometricsEnabled;

  @override
  Future<bool> areBiometricsEnabled() async => _areBiometricsEnabled ?? false;

  @override
  Future<void> setBiometricsEnabled(bool enable) async =>
      _areBiometricsEnabled = enable;
}