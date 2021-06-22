import 'hotels_data_source.dart';
import 'hotels_firebase_data_source.dart';

class HotelsRemoteDataSourceFactory {
  static HotelsDataSource withFirebaseDataSource() =>
      HotelsFirebaseDataSource();
}
