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

  static HotelsDataSource fromInput(String input) {
    switch (input) {
      case 'local':
        return withLocalDataSource();
      case 'firebase':
        return withFirebaseDataSource();
      case 'firebase_algolia':
        return withFirebaseAlgoliaDataSource();
      default:
        return withLocalDataSource();
    }
  }
}
