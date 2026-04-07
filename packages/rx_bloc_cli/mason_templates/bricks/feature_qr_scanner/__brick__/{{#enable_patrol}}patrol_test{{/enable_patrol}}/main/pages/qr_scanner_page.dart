{{> licence.dart }}

import '../base/base_page.dart';
import '../configuration/build_app.dart';

class QrScannerPage extends BasePage {
  QrScannerPage(super.$);

  Future<void> grantPermissions() async {
    if (await $.platformAutomator.mobile.isPermissionDialogVisible(
      timeout: const Duration(seconds: 10),
    )) {
      await $.platformAutomator.mobile.grantPermissionOnlyThisTime();
    }
  }
}
