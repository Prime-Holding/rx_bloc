import '../../helpers/golden_helper.dart';
import '../factory/sample_factory.dart';


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