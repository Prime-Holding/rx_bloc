{{> licence.dart }}

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:testapp/main.dart' as app;

export 'package:flutter/foundation.dart';
export 'package:flutter_test/flutter_test.dart';
export 'package:patrol/patrol.dart';

class BuildApp {
  late PatrolTester $;

  BuildApp(this.$);

  Future<void> buildApp() async {
    final FlutterExceptionHandler? originalOnError = FlutterError.onError;

    /// The next row have to be manually modified with another relevant suffix
    /// if a different flavor will be used for testing
    app.main();
    await $.pumpAndSettle();
    FlutterError.onError = originalOnError;
  }
}
