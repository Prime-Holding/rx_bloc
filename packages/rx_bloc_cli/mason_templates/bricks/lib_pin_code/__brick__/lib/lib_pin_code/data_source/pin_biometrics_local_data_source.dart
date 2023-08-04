{{> licence.dart }}

import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import '../../base/data_sources/local/shared_preferences_instance.dart';

/// You have to implement and provide a [BiometricsLocalDataSource], you can
/// store the value of [_areBiometricsEnabled], for example in [SharedPreferences]
class PinBiometricsLocalDataSource implements BiometricsLocalDataSource {
  PinBiometricsLocalDataSource(this._sharedPreferences);

  final SharedPreferencesInstance _sharedPreferences;

  /// This value is the state for the user general choice for the app
  static const _areBiometricsEnabled = 'areBiometricsEnabled';

  /// This value is set temporarily when changing the pin
  static const _disableBiometrics = 'disableBiometrics';

  @override
  Future<bool> areBiometricsEnabled() async {
    bool? disableBiometrics = await _getBoolValue(_disableBiometrics);
    if (disableBiometrics == true) {
      await _setBoolValue(_disableBiometrics, false);
      return false;
    }
    return await _getBoolValue(_areBiometricsEnabled) ?? false;
  }

  @override
  Future<void> setBiometricsEnabled(bool enable) async {
    if (!enable) {
      await _setBoolValue(_disableBiometrics, true);
      return;
    }
    await _setBoolValue(_areBiometricsEnabled, enable);
  }

  Future<bool> _setBoolValue(String key, bool value) async =>
      await _sharedPreferences.setBool(key, value);

  Future<bool?> _getBoolValue(String key) async =>
      await _sharedPreferences.getBool(key);
}
