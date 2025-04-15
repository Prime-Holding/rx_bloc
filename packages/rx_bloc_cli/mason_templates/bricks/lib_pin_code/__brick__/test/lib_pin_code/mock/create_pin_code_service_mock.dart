import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/feature_pin_code/services/create_pin_code_service.dart';

import 'create_pin_code_service_mock.mocks.dart';

@GenerateMocks([CreatePinCodeService])
CreatePinCodeService createPinCodeServiceMockFactory() {
  final mockCreatePinCodeService = MockCreatePinCodeService();

  when(mockCreatePinCodeService.getPinCode()).thenAnswer((_) async => '1234');

  when(mockCreatePinCodeService.getPinLength()).thenAnswer((_) async => 4);

  return mockCreatePinCodeService;
}
