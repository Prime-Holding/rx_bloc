import 'package:booking_app/main_dev.dart' as app_dev;
import 'package:booking_app/main_sit.dart' as app_sit;
import 'package:booking_app/main_uat.dart' as app_uat;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

export 'package:flutter/foundation.dart';
export 'package:flutter_test/flutter_test.dart';
export 'package:patrol/patrol.dart';

const String env = String.fromEnvironment('flavor');

class BuildApp {
  late PatrolIntegrationTester $;

  BuildApp(this.$);

  Future<void> buildApp() async {
    final FlutterExceptionHandler? originalOnError = FlutterError.onError;

    switch (env) {
      case 'dev':
      case 'development':
        app_dev.main();
        break;
      case 'uat':
        app_uat.main();
        break;
      default:
        app_sit.main();
    }
    await $.pumpAndSettle();
    FlutterError.onError = originalOnError;
  }
}
