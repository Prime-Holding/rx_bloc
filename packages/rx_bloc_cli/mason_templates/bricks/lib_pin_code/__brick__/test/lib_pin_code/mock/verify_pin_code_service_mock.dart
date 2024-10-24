import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/lib_pin_code/services/verify_pin_code_service.dart';

import 'verify_pin_code_service_mock.mocks.dart';

@GenerateMocks([VerifyPinCodeService])
VerifyPinCodeService verifyPinCodeServiceMockFactory({
  bool showBiometricsButton = false,
}) {
  final mockVerifyPinCodeService = MockVerifyPinCodeService();

  if (showBiometricsButton) {
    when(mockVerifyPinCodeService.isPinCodeInSecureStorage())
        .thenAnswer((_) async => true);
  }

  return mockVerifyPinCodeService;
}
