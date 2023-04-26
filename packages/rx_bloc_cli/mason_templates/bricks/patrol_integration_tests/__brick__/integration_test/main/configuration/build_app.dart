{{> licence.dart }}

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:testapp/main.dart' as app;
import 'package:testapp/main_dev.dart' as app_dev;
import 'package:testapp/main_staging.dart' as app_staging;

export 'package:flutter/foundation.dart';
export 'package:flutter_test/flutter_test.dart';
export 'package:patrol/patrol.dart';

const String env = String.fromEnvironment('flavor');

class BuildApp {
  late PatrolTester $;

  BuildApp(this.$);

  Future<void> buildApp() async {
    final FlutterExceptionHandler? originalOnError = FlutterError.onError;

    /// The next row have to be manually modified with another relevant suffix
    /// if a different flavor will be used for testing
    switch (env) {
      case 'development':
        app_dev.main();
        break;
      case 'staging':
        app_staging.main();
        break;
      default:
        app.main();
    }
    FlutterError.onError = originalOnError;
  }
}
