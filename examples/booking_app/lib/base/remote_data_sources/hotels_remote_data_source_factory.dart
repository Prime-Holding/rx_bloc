import 'package:favorites_advanced_base/core.dart';

import 'hotels_firebase_data_source.dart';

class HotelsRemoteDataSourceFactory {
  static HotelsDataSource withFirebaseDataSource() =>
      HotelsFirebaseDataSource();
}
