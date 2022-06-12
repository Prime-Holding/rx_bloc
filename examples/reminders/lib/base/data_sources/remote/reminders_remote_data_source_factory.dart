import '../../app/config/environment_config.dart';
import '../local/reminders_local_data_source.dart';
import 'reminders_data_source.dart';
import 'reminders_firebase_data_source.dart';

class RemindersRemoteDataSourceFactory {
  static RemindersDataSource withFirebaseDataSource() =>
      RemindersFirebaseDataSource();

  static RemindersDataSource withLocalDataSource() =>
      RemindersLocalDataSource();

  static RemindersDataSource fromConfig(EnvironmentConfig config) {
    switch (config) {
      case EnvironmentConfig.dev:
        return withLocalDataSource();
      case EnvironmentConfig.prod:
        return withFirebaseDataSource();
      default:
        return withLocalDataSource();
    }
  }
}
