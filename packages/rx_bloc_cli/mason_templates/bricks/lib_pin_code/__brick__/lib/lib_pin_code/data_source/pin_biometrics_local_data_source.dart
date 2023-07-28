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

  /// This value is changed, while using the app to stop and start automatic
  /// biometrics authentication
  bool? _disabled = false;

  Future<void> temporaryDisableBiometrics(bool disable) async =>
      _disabled = disable;

  @override
  Future<bool> areBiometricsEnabled() async {
    if (_disabled == true) {
      return false;
    }
    final areBiometricsEnabled =
        await _getBoolValue(_areBiometricsEnabled) ?? false;
    _disabled = false;
    return areBiometricsEnabled;
  }

  @override
  Future<void> setBiometricsEnabled(bool enable) async {
    await _setBoolValue(_areBiometricsEnabled, enable);
  }

  Future<bool> _setBoolValue(String key, bool value) async =>
      await _sharedPreferences.setBool(key, value);

  Future<bool?> _getBoolValue(String key) async =>
      await _sharedPreferences.getBool(key);
}
