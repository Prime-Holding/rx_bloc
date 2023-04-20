import 'package:testapp/main.dart' as app;

import '../main/base/common.dart';
import '../main/pages/counter_page.dart';
import '../main/pages/home_page.dart';
import '../main/pages/login_page.dart';
import '../main/pages/profile_page.dart';
import '../main/steps_utils/counter_utils.dart';

void main() {
  LoginPagePatrol loginPagePatrol;
  HomePagePatrol homePagePatrol;
  CounterPagePatrol counterPagePatrol;
  ProfilePagePatrol profilePagePatrol;
  patrol(
    'Test flow of user login in, navigating to counter page,'
    'incrementing counter and expecting appropriate states,'
    'decrementing counter and expecting appropriate states,'
    'and navigating to the profile page and logging out',
    (tester) async {
      app.main();
      final CounterUtils counterUtils = CounterUtils(tester);
      loginPagePatrol = LoginPagePatrol(tester);
      homePagePatrol = HomePagePatrol(tester);
      counterPagePatrol = CounterPagePatrol(tester);
      profilePagePatrol = ProfilePagePatrol(tester);
      //Log in
      await counterUtils.loginAction(loginPagePatrol);
      //Navigate to counter page
      await homePagePatrol.tapBtnCalcPage();
      //Increment counter 5 times
      await counterUtils.incrementAction(counterPagePatrol);
      //Show error modal on increment
      await counterUtils.showErrorModalSheetIncrement(counterPagePatrol);
      //Decrement counter 5 times
      await counterUtils.decrementAction(counterPagePatrol);
      //Show error modal on Decrement
      await counterUtils.showErrorModalSheetDecrement(counterPagePatrol);
      //Tap reload button and expect same counter value
      await counterUtils.reloadCounter(counterPagePatrol);
      //Logout
      await counterUtils.logout(homePagePatrol, profilePagePatrol);
    },
  );
}
