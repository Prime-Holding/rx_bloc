import 'package:mockito/annotations.dart';
import 'package:{{project_name}}/lib_pin_code/services/pin_biometrics_service.dart';

import 'pin_biometrics_service_mock.mocks.dart';

@GenerateMocks([
  PinBiometricsService,
])
PinBiometricsService pinBiometricsServiceMockFactory() =>
    MockPinBiometricsService();
