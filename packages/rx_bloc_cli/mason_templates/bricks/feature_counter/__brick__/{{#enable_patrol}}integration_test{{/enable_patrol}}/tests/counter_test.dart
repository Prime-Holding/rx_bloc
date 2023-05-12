{{> licence.dart }}

import '../main/configuration/build_app.dart';
import '../main/configuration/patrol_base_config.dart';
import '../main/steps_utils/counter_page_steps.dart';
import '../main/steps_utils/home_page_steps.dart';
import '../main/steps_utils/login_page_steps.dart';
import '../main/steps_utils/profile_page_steps.dart';

void main() {
  final patrolBaseConfig = PatrolBaseConfig();
  patrolBaseConfig.patrol(
    'Test flow of user login in, navigating to counter page,'
    'incrementing counter and expecting appropriate states,'
    'decrementing counter and expecting appropriate states,'
    'and navigating to the profile page and logging out',
    ($) async {
      BuildApp app = BuildApp($);
      await app.buildApp();

      //Log in
      await LoginPageSteps.loginAction($);
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
      await CounterPageSteps.reloadCounter($);
      //Logout
      await ProfilePageSteps.logout($);
    },
  );
}
