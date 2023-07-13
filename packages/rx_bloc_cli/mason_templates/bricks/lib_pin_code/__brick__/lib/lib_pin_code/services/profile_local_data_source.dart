{{> licence.dart }}

import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import '../../base/data_sources/local/shared_preferences_instance.dart';

/// You have to implement and provide a [BiometricsLocalDataSource], you can
/// store the value of [_areBiometricsEnabled], for example in [SharedPreferences]
class ProfileLocalDataSource implements BiometricsLocalDataSource {
  ProfileLocalDataSource({
    required this.sharedPreferences,
  });

  bool? onRestart;
  final SharedPreferencesInstance sharedPreferences;

  /// This value is the state for the user general choice for the app
  static const _areBiometricsEnabled = 'areBiometricsEnabled';

  /// This value is changed in while using the app to stop and start auto biometrics
  static const _areBiometricsEnabledWhileUsingTheApp =
      'areBiometricsEnabledWhileUsingTheApp';

  Future<bool> temporaryDisableBiometrics(bool disable) async {
    if (disable) {
      await sharedPreferences.setString(
          _areBiometricsEnabledWhileUsingTheApp, 'false');
    } else {
      await sharedPreferences.setString(
          _areBiometricsEnabledWhileUsingTheApp, 'true');
    }
    return false;
  }

  @override
  Future<bool> areBiometricsEnabled() async {
    if (onRestart == null) {
// If biometrics were saved before while using the app, set the previous
// value once
      var areBiometricsEnabled =
          await sharedPreferences.getBool(_areBiometricsEnabled);
      if (areBiometricsEnabled == true) {
        await sharedPreferences.setString(
            _areBiometricsEnabledWhileUsingTheApp, 'true');
      } else if (areBiometricsEnabled == false) {
        await sharedPreferences.setString(
            _areBiometricsEnabledWhileUsingTheApp, 'false');
      }
      onRestart = false;
    }

    final areEnabledBefore = await sharedPreferences
        .getString(_areBiometricsEnabledWhileUsingTheApp);

    if (areEnabledBefore == 'true') {
      return true;
    }
    return false;
  }

  @override
  Future<void> setBiometricsEnabled(bool enable) async {
    await sharedPreferences.setString(
        _areBiometricsEnabledWhileUsingTheApp, enable.toString());
    await sharedPreferences.setBool(_areBiometricsEnabled, enable);
  }
}
