import 'package:intl/intl.dart';

import '../configuration/build_app.dart';

abstract class Utils {
  late PatrolIntegrationTester $;

  Utils(this.$);

  static DateFormat formattedDate = DateFormat('HH-mm-ss');

  static Future<void> setUpApp(PatrolIntegrationTester $) =>
      BuildApp($).buildApp();

  static Future<void> enableNetwork(PatrolIntegrationTester $) async {
    await $.native.enableWifi();
    await $.native.enableCellular();
    await Future.delayed(const Duration(seconds: 1));
  }

  static void disableNetwork(PatrolIntegrationTester $) {
    $.native.disableWifi();
    $.native.disableCellular();
  }
}
