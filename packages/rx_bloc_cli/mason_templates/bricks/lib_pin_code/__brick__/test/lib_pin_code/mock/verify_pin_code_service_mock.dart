import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/feature_pin_code/services/verify_pin_code_service.dart';

import 'verify_pin_code_service_mock.mocks.dart';

@GenerateMocks([VerifyPinCodeService])
VerifyPinCodeService verifyPinCodeServiceMockFactory({
  bool showBiometricsButton = false,
}) {
  final mockVerifyPinCodeService = MockVerifyPinCodeService();

  when(mockVerifyPinCodeService.savePinCodeInSecureStorage('1234'))
      .thenAnswer((_) async => showBiometricsButton);

  when(mockVerifyPinCodeService.getPinLength()).thenAnswer((_) async => 4);

  when(mockVerifyPinCodeService.getPinCode()).thenAnswer((_) async => '1234');

  return mockVerifyPinCodeService;
}
