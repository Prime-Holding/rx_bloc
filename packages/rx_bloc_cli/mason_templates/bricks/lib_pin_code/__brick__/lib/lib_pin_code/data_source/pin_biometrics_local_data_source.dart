// {{> licence.dart }}

import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import '../../base/data_sources/local/shared_preferences_instance.dart';

/// You have to implement and provide a [BiometricsLocalDataSource], you can
/// store the value of [_areBiometricsEnabled], for example in [SharedPreferences]
class PinBiometricsLocalDataSource implements BiometricsLocalDataSource {
  PinBiometricsLocalDataSource(
    this._sharedPreferences,
  );

  bool? onRestart;
  final SharedPreferencesInstance _sharedPreferences;

  /// This value is the state for the user general choice for the app
  static const _areBiometricsEnabled = 'areBiometricsEnabled';

  /// This value is changed in while using the app to stop and start auto biometrics
  static const _areBiometricsEnabledWhileUsingTheApp =
      'areBiometricsEnabledWhileUsingTheApp';

  Future<void> temporaryDisableBiometrics(bool disable) async =>
      await _setBoolValue(_areBiometricsEnabledWhileUsingTheApp, !disable);

  @override
  Future<bool> areBiometricsEnabled() async {
    if (onRestart == null) {
      var areBiometricsEnabled = await _getBoolValue(_areBiometricsEnabled);
      if (areBiometricsEnabled == true) {
        await _setBoolValue(_areBiometricsEnabledWhileUsingTheApp, true);
      } else if (areBiometricsEnabled == false) {
        await _setBoolValue(_areBiometricsEnabledWhileUsingTheApp, false);
      }
      onRestart = false;
    }

    final areEnabledBefore =
        await _getBoolValue(_areBiometricsEnabledWhileUsingTheApp);

    if (areEnabledBefore == true) {
      return true;
    }
    return false;
  }

  @override
  Future<void> setBiometricsEnabled(bool enable) async {
    await _setBoolValue(_areBiometricsEnabledWhileUsingTheApp, enable);
    await _setBoolValue(_areBiometricsEnabled, enable);
  }

  Future<bool> _setBoolValue(String key, bool value) async =>
      await _sharedPreferences.setBool(key, value);

  Future<bool?> _getBoolValue(String key) async =>
      await _sharedPreferences.getBool(key);
}
