{{> licence.dart }}

import '../main/base/tags.dart';
import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/counter_page_steps.dart';
import '../main/steps_utils/home_page_steps.dart';{{#has_authentication}}
import '../main/steps_utils/login_page_steps.dart';
{{#enable_feature_otp}}import '../main/steps_utils/otp_page_steps.dart';{{/enable_feature_otp}}
import '../main/steps_utils/profile_page_steps.dart';{{/has_authentication}}

void main() {
  final patrolBaseConfig = PatrolBaseConfig();
    patrolBaseConfig.patrol(
      'Counter test',
      ($) async {
      BuildApp app = BuildApp($);
      await app.buildApp();
      {{#has_authentication}}
      //Log in
      await LoginPageSteps.loginAction($);{{/has_authentication}}
      {{#enable_feature_otp}}
      await OtpPageSteps.otpAction($);
      {{/enable_feature_otp}}
      //Navigate to counter page
      await HomePageSteps.navigateToCounterPage($);
      //Increment counter 5 times
      await CounterPageSteps.incrementAction($);
      //Show error modal on increment
      await CounterPageSteps.showErrorModalSheetIncrement($);
      //Decrement counter 5 times
      await CounterPageSteps.decrementAction($);
      //Show error modal on Decrement
      await CounterPageSteps.showErrorModalSheetDecrement($);
      //Tap reload button and expect same counter value
      await CounterPageSteps.reloadCounter($);{{#has_authentication}}
      //Logout
      await ProfilePageSteps.logout($);{{/has_authentication}}
    },
    tags: [regressionTest, positiveTest],
  );
}
