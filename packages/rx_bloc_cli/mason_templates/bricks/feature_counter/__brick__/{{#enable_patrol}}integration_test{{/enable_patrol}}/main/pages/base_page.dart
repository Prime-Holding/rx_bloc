import '../base/common.dart';

class BasePagePatrol {
  final PatrolTester tester;

  BasePagePatrol(this.tester);

  Future<void> tapElement(Finder element, {bool andSettle = true}) async {
    await tester.waitUntilVisible(element);
    await tester(element).tap(andSettle: andSettle);
  }

  Future<void> setText(Finder inputField, String text) async {
    await tester.waitUntilVisible(inputField);
    await tester.enterText(inputField, text);
    await tester.pumpAndSettle();
  }

  Future<bool> isDisplayed(Finder element) async {
    return element.evaluate().isNotEmpty ? true : false;
  }

  Future<bool> isVisible(Finder element) async {
    return tester(element).visible ? true : false;
  }
}
