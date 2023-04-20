import '../base/common.dart';
import '../pages/counter_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/profile_page.dart';

class CounterUtils {
  CounterUtils(this.$);
  final PatrolTester $;

  Future<void> loginAction(LoginPagePatrol loginPagePatrol) async {
    await loginPagePatrol.setTextEmail();
    await loginPagePatrol.setTextPassword();
    await loginPagePatrol.tapLoginButton();
  }

  Future<void> incrementAction(CounterPagePatrol counterPagePatrol) async {
    await $.pumpAndSettle();
    for (int i = 1; i <= 5; i++) {
      await counterPagePatrol.tapBtnIncrement();
      expect(
          await counterPagePatrol.isSpinnerIncrementDisplayed(), equals(true));
      await $.pumpAndSettle();
      expect(await counterPagePatrol.getCounterValue(), equals(i));
    }
  }

  Future<void> decrementAction(CounterPagePatrol counterPagePatrol) async {
    await $.pumpAndSettle();
    for (int i = 5; i > 0; i--) {
      await counterPagePatrol.tapBtnDecrement();
      expect(
          await counterPagePatrol.isSpinnerDecrementDisplayed(), equals(true));
      expect(await counterPagePatrol.getCounterValue(), equals(i));
    }
  }

  Future<void> showErrorModalSheetIncrement(
      CounterPagePatrol counterPagePatrol) async {
    await counterPagePatrol.tapBtnIncrement();
    await $.pumpAndSettle();
    expect(await counterPagePatrol.isModalErrorDisplayed(), true);
    await $.pumpAndSettle();
    await counterPagePatrol.tapBtnError();
  }

  Future<void> showErrorModalSheetDecrement(
      CounterPagePatrol counterPagePatrol) async {
    await counterPagePatrol.tapBtnDecrement();
    await $.pumpAndSettle();
    expect(await counterPagePatrol.isModalErrorDisplayed(), true);
    await $.pumpAndSettle();
    await counterPagePatrol.tapBtnError();
  }

  Future<void> reloadCounter(CounterPagePatrol counterPagePatrol) async {
    await counterPagePatrol.tapBtnReload();
    expect(await counterPagePatrol.isTextCountDisplayed(), true);
  }

  Future<void> logout(HomePagePatrol homePagePatrol,
      ProfilePagePatrol profilePagePatrol) async {
    await homePagePatrol.tapBtnProfilePage();
    await profilePagePatrol.tapBtnLogout();
  }
}
