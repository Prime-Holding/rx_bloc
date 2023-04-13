import 'package:flutter/material.dart';
import 'package:testapp/base/common_ui_components/action_button.dart';
import 'package:testapp/keys.dart';
import 'package:testapp/main.dart' as app;

import '../common.dart';
import '../utils/counter_helper.dart';

void main() {
  patrol(
    'Test weather counter feature displays appropriate states',
    ($) async {
      app.main();
      final CounterHelper inc = CounterHelper($);
      //Log in
      await $(K.loginEmailKey).enterText('admin@email.com');
      await $(K.loginPasswordKey).enterText('123456');
      await $(K.loginButtonKey).tap();
      expect($(K.bottomNavigationBarKey), findsOneWidget);

      //Navigate to counter page
      await $(find.byIcon(Icons.calculate)).tap();
      await $.pumpAndSettle();

      //Get value of the counter
      int textValue = int.parse($(K.counterCountKey).text!);
      expect(int.parse($(K.counterCountKey).text!), equals(textValue));

      //Increment counter 5 times
      for (int i = 0; i < 5; i++) {
        await inc.tapActionButton(
          find.byType(ActionButton),
          K.counterIncrementKey,
          K.appLoadingIndicatorIncrementKey,
          ++textValue,
        );
      }
      //Show error modal on increment
      await inc.showErrorModalSheet(K.counterIncrementKey);

      //Decrement 5 times
      for (int i = 0; i < 5; i++) {
        await inc.tapActionButton(
          find.byType(ActionButton),
          K.counterDecrementKey,
          K.appLoadingIndicatorDecrementKey,
          --textValue,
        );
      }
      //Show error modal on decrement
      await inc.showErrorModalSheet(K.counterDecrementKey);

      //Tap reload button and expect same counter value
      await $(K.counterReloadKey).tap();
      await $.pumpAndSettle();
      expect(int.parse($(K.counterCountKey).text!), equals(textValue));

      //Logout
      await $.tap(find.byIcon(Icons.account_box));
      await $.tap(find.byIcon(Icons.logout));
      expect($(K.loginButtonKey), findsOneWidget);
    },
  );
}
