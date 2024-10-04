import 'package:mockito/annotations.dart';
import 'package:{{project_name}}/lib_pin_code/services/create_pin_code_service.dart';

import 'create_pin_code_service_mock.mocks.dart';

@GenerateMocks([
  CreatePinCodeService,
])
CreatePinCodeService createPinCodeServiceMockFactory() =>
    MockCreatePinCodeService();
