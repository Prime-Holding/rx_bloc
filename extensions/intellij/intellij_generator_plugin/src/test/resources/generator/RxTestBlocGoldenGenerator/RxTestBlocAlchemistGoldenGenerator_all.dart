import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '../factory/sample_factory.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';


void main() {
  runGoldenTests([
    buildScenario(
      scenario:  'sample_empty',
      widget: sampleFactory(),
    ),
    buildScenario(
      scenario:  'sample_success',
      widget: sampleFactory(),
    ),
    buildScenario(
      scenario:  'sample_loading',
      widget: sampleFactory(),
    ),
    buildScenario(
      scenario:  'sample_error',
      widget: sampleFactory(),
    ),
  ]);
}