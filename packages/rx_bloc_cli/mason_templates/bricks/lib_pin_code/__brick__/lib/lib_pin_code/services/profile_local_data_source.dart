{{> licence.dart }}

import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import '../../base/data_sources/local/shared_preferences_instance.dart';

/// You have to implement and provide a [BiometricsLocalDataSource], you can
/// store the value of [_areBiometricsEnabled], for example in [SharedPreferences]
class ProfileLocalDataSource implements BiometricsLocalDataSource {
  ProfileLocalDataSource({
    required this.sharedPreferences,
  });

  final SharedPreferencesInstance sharedPreferences;

  static const _areBiometricsEnabled = 'areBiometricsEnabled';
  static const _isAuthenticated = 'isAuthenticated';
  static const _isAuthenticatedWithBiometrics = 'isAuthenticatedWithBiometrics';

  @override
  Future<bool> areBiometricsEnabled() async {
    final areEnabled = await sharedPreferences.getBool(_areBiometricsEnabled);

    return areEnabled ?? false;
  }

  @override
  Future<void> setBiometricsEnabled(bool enable) async {
    final storage = sharedPreferences;
    await storage.setBool(_areBiometricsEnabled, enable);
  }

  Future<bool> isAuthenticatedWithBiometrics(
      bool? isAuthenticatedWithBiometrics) async {
    if (isAuthenticatedWithBiometrics == true) {
      await sharedPreferences.setBool(_isAuthenticated, true);
      await sharedPreferences.setBool(_isAuthenticatedWithBiometrics, true);
      return true;
    }
    return false;
  }
}
