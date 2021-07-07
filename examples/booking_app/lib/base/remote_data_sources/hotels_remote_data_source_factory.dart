import 'package:booking_app/base/config/environment_config.dart';
import 'package:booking_app/base/local_data_sources/hotels_local_data_source.dart';
import 'package:booking_app/base/remote_data_sources/hotels_firebase_algolia_data_source.dart';
import 'package:favorites_advanced_base/core.dart';

import 'hotels_data_source.dart';
import 'hotels_firebase_data_source.dart';

class HotelsRemoteDataSourceFactory {
  static HotelsDataSource withFirebaseDataSource() =>
      HotelsFirebaseDataSource();

  static HotelsDataSource withFirebaseAlgoliaDataSource() =>
      HotelsFirebaseAlgoliaDataSource();

  static HotelsDataSource withLocalDataSource() =>
      HotelsLocalDataSource(connectivityRepository: ConnectivityRepository());

  static HotelsDataSource fromConfig(EnvironmentConfig config) {
    switch (config) {
      case EnvironmentConfig.local:
        return withLocalDataSource();
      case EnvironmentConfig.firebase:
        return withFirebaseDataSource();
      case EnvironmentConfig.firebaseAlgolia:
        return withFirebaseAlgoliaDataSource();
      default:
        return withLocalDataSource();
    }
  }
}
