import '../../app/config/environment_config.dart';
import '../local/reminders_local_data_source.dart';
import 'reminders_data_source.dart';
import 'reminders_firebase_data_source.dart';

class RemindersRemoteDataSourceFactory {
  static RemindersDataSource _withFirebaseDataSource() =>
      RemindersFirebaseDataSource();

  static RemindersDataSource _withLocalDataSource() =>
      RemindersLocalDataSource();

  static RemindersDataSource fromConfig(EnvironmentConfig config) {
    switch (config) {
      case EnvironmentConfig.dev:
        return _withLocalDataSource();
      case EnvironmentConfig.prod:
        return _withFirebaseDataSource();
      default:
        return _withLocalDataSource();
    }
  }
}
