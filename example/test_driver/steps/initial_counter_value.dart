import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import '../pages/home_page.dart';

class InitialCounterValue extends GivenWithWorld<FlutterWorld> {
  InitialCounterValue()
      : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  Future<void> executeStep() async {
    HomePage homePage = HomePage(world.driver);

    expect(await homePage.getCounterValue(), "0");
  }

  @override
  RegExp get pattern => RegExp(r"I test the initial state of the app with value as 0");
}

