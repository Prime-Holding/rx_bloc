import 'package:mockito/annotations.dart';
import 'package:testapp/lib_pin_code/repository/pin_code_repository.dart';
import 'package:testapp/lib_pin_code/services/create_pin_code_service.dart';

import 'create_pin_service_mock.mocks.dart';

@GenerateMocks([PinCodeRepository])
CreatePinCodeService createPinServiceMockFactory() {
  final repositoryMock = MockPinCodeRepository();

  return CreatePinCodeService(repositoryMock);
}
