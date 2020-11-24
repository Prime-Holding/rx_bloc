import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import '../pages/home_page.dart';

class CounterNewState extends ThenWithWorld<FlutterWorld> {
  CounterNewState()
      : super(StepDefinitionConfiguration()..timeout = Duration(seconds: 10));

  @override
  Future<void> executeStep() async {
    HomePage homePage = HomePage(world.driver);

    expect(await homePage.getCounterValue(), "1");
  }

  @override
  RegExp get pattern => RegExp(r"I see if the values is 1");
}