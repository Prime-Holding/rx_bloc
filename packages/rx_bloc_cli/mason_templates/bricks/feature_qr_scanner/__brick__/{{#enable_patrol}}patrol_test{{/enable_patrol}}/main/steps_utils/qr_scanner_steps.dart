{{> licence.dart }}

import '../configuration/build_app.dart';
import '../pages/qr_scanner_page.dart';

class QrScannerSteps {
  static Future<void> grantCameraPermissions(PatrolIntegrationTester $) async {
    QrScannerPage qrScannerPage = QrScannerPage($);
    await qrScannerPage.grantPermissions();
    await $.pumpAndSettle();
  }
}
