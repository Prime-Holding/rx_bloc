import 'package:favorites_advanced_base/core.dart';

import 'hotels_firebase_data_source.dart';

class HotelsRemoteDataSourceFactory {
  static HotelsDataSource withLocalDataSource() => HotelsLocalDataSource(
      multiplier: 100, connectivityRepository: ConnectivityRepository());

  static HotelsDataSource withFirebaseDataSource() =>
      HotelsFirebaseDataSource();
}
