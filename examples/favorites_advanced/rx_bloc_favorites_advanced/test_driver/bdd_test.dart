import 'dart:async';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/puppy_list_steps.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [
      // Features go here
      Glob(r'test_driver/features/puppy_details.feature'),
    ]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: 'test_driver/reports/report.json')
    ]
    ..order = ExecutionOrder.sequential
    ..hooks = [AttachScreenshotOnFailedStepHook()]
    ..stepDefinitions = [
      // Custom step definitions go here
      tapOnPuppyCard(),
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test_driver/bdd.dart'
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}
