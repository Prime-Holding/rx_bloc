import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';

class BiometricsDataSource implements BiometricsLocalDataSource {
  static const _areBiometricsEnabled = 'areBiometricsEnabled';

  Future<SharedPreferences> get _storageInstance =>
      SharedPreferences.getInstance();

  @override
  Future<bool> areBiometricsEnabled() async {
    final storage = await _storageInstance;
    return storage.getBool(_areBiometricsEnabled) ?? false;
  }

  @override
  Future<void> setBiometricsEnabled(bool enable) async {
    final storage = await _storageInstance;
    await storage.setBool(_areBiometricsEnabled, enable);
  }
}
