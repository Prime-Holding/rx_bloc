import '../../base/data_sources/local/shared_preferences_instance.dart';

class DevMenuDataSource {
  DevMenuDataSource();

  Future<void> saveProxy(String proxy) async {
    await SharedPreferencesInstance().setString('proxy', proxy);
  }
}
