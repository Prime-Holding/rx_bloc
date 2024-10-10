import 'package:mockito/annotations.dart';
import 'package:{{project_name}}/lib_pin_code/services/update_pin_code_service.dart';

import 'update_pin_code_service_mock.mocks.dart';

@GenerateMocks([
  UpdatePinCodeService,
])
UpdatePinCodeService updatePinCodeServiceMockFactory() =>
    MockUpdatePinCodeService();
