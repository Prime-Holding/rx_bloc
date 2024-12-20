import 'package:{{project_name}}/base/models/errors/error_model.dart';

import '../../helpers/golden_helper.dart';
import '../factory/profile_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'profile_success',
      widget: profileFactory( {{#enable_pin_code}}
        isPinCreated: true, 
        isDeviceSupported: true,{{/enable_pin_code}}
      ),
    ),
    buildScenario(
      scenario: 'profile_error',
      widget: profileFactory( {{#enable_pin_code}}
        isDeviceSupported: true, {{/enable_pin_code}}
        errors: UnknownErrorModel(
          exception: Exception('Something went wrong'),
        ),
      ),
    ),
  ]);
}
