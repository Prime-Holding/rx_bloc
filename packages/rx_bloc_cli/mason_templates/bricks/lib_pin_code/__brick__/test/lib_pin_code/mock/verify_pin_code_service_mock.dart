import 'package:mockito/annotations.dart';
import 'package:{{project_name}}/lib_pin_code/repository/pin_code_repository.dart';
import 'package:{{project_name}}/lib_pin_code/services/verify_pin_code_service.dart';

import 'verify_pin_code_service_mock.mocks.dart';

@GenerateMocks([
  VerifyPinCodeService,
  PinCodeRepository
])
VerifyPinCodeService verifyPinCodeServiceMockFactory() {
  PinCodeRepository repositoryMock = MockPinCodeRepository();
  return VerifyPinCodeService(repositoryMock);
}
