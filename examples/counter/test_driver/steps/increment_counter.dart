import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import '../pages/home_page.dart';

class IncrementCounter extends AndWithWorld<FlutterWorld> {
  IncrementCounter()
      : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  Future<void> executeStep() async {
    HomePage homePage = HomePage(world.driver);

    await homePage.tapIncrementBtn();
  }

  @override
  RegExp get pattern => RegExp(r"I click the Increment button");
}