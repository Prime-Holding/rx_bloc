import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../configuration/config_params.dart';

abstract class BasePage {
  late PatrolIntegrationTester $;

  BasePage(this.$);

  Future<void> swipeRight() async {
    await $.native
        .swipe(from: const Offset(0.2, 0.5), to: const Offset(0.8, 0.5));
  }

  Future<void> swipeLeft() async {
    await $.native
        .swipe(from: const Offset(0.8, 0.5), to: const Offset(0.2, 0.5));
  }

  Future<void> scrollToAndTapWidget(var widget,
      [SettlePolicy? settlePolicy]) async {
    await $(widget).scrollTo().tap(settlePolicy: settlePolicy);
  }

  Future<void> tapWidget(var widget, [SettlePolicy? settlePolicy]) async {
    await $(widget).tap(settlePolicy: settlePolicy);
  }

  Future<void> setText(var widget, String inputText) async {
    await $(widget).scrollTo().enterText(inputText);
  }

  Future<void> scrollToAndVerifyWidgetText(
      var widget, String expectedString) async {
    await $(widget).scrollTo();
    verifyWidgetText(widget, expectedString);
  }

  Future<String?> scrollToAndGetWidgetText(var widget) async {
    await $(widget).scrollTo();
    return $(widget).text;
  }

  Future<bool> isElevatedButtonEnabled(var widget) async {
    final elevatedButton = $(widget).evaluate().first.widget as ElevatedButton;
    return elevatedButton.enabled == true;
  }

  Future<void> nativeBack() async => await $.native.pressBack();

  String? getWidgetText(var widget) {
    final textField = $(widget).evaluate().first.widget as Text;
    return $(textField).text;
  }

  bool doesWidgetTextContain(var widget) {
    final textField = $(widget).evaluate().first.widget as Text;
    return $(textField).text == '';
  }

  Future<void> checkWidgetVisibility(var widget,
      [Duration timeout = ConfigParams.generalVisibleTimeout]) async {
    await $(widget).waitUntilVisible(timeout: timeout);
  }

  Future<void> checkPageVisibility(var page,
          [Duration timeout = ConfigParams.pageVisibleTimeout]) async =>
      await checkWidgetVisibility(page, timeout);

  Future<void> isPageLoaded() async {}

  void expectWidgetIsVisible(var widget) =>
      expect($(widget).visible, equals(true));

  bool isWidgetVisible(var widget) => $(widget).visible;

  bool isWidgetExists(var widget) => $(widget).exists;

  Future<void> clearTextField(var widget) async =>
      await $(widget).scrollTo().enterText('');

  void verifyAppShimmerWidgetText(var shimmerWidget, String expectedText) {
    var textWidget = $(shimmerWidget).$(Text);
    verifyWidgetText(textWidget, expectedText);
  }

  void verifyAppShimmerWidgetTextContains(
      var shimmerWidget, String expectedText) {
    var textWidget = $(shimmerWidget).$(Text);
    verifyWidgetTextContains(textWidget, expectedText);
  }

  void verifyWidgetText(var widget, String expectedText) =>
      expect($(widget).text, expectedText);

  void verifyWidgetTextContains(var widget, String expectedText) =>
      expect($(widget).text?.contains(expectedText), true);
}
