import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../pages/search_puppy_page.dart';

StepDefinitionGeneric TapOnPuppyCard() => and1<String, FlutterWorld>(
      'I press the puppy card with id {string}',
      (value, context) async =>
          SearchPuppyPage(context.world.driver).tapOnPuppyWithId(value),
    );
