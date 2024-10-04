import 'package:mockito/annotations.dart';
import 'package:{{project_name}}/lib_pin_code/services/verify_pin_code_service.dart';

import 'verify_pin_code_service_mock.mocks.dart';

@GenerateMocks([
  VerifyPinCodeService,
])
VerifyPinCodeService verifyPinCodeServiceMockFactory() =>
    MockVerifyPinCodeService();
