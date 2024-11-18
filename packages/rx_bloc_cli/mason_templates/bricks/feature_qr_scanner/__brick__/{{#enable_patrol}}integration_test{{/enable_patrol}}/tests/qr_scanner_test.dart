{{> licence.dart }}

import '../main/base/tags.dart';
import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/home_page_steps.dart';{{#has_authentication}}
import '../main/steps_utils/login_page_steps.dart';
{{#enable_feature_otp}}import '../main/steps_utils/otp_page_steps.dart';{{/enable_feature_otp}}
import '../main/steps_utils/profile_page_steps.dart';{{/has_authentication}}
import '../main/steps_utils/qr_scanner_steps.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();
  patrolBaseConfig.patrol(
    'Qr scanner grant permission test',
    ($) async {
      BuildApp app = BuildApp($);
      await app.buildApp();
      {{#has_authentication}}
      //Log in
      await LoginPageSteps.loginAction($);{{/has_authentication}}
      {{#enable_feature_otp}}
      await OtpPageSteps.otpAction($);
      {{/enable_feature_otp}}
      //Navigate to qr scanner page
      await HomePageSteps.navigateToQrScannerPage($);
      //Grant camera permissions
      await QrScannerSteps.grantCameraPermissions($);
      {{#has_authentication}}
      //Logout
      await ProfilePageSteps.logout($);{{/has_authentication}}
    },
    tags: [regressionTest, positiveTest],
  );
}
