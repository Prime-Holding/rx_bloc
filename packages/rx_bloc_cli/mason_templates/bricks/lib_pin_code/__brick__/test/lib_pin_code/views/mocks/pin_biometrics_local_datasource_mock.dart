
import 'package:mockito/annotations.dart';
import 'package:{{project_name}}/lib_pin_code/data_source/pin_biometrics_local_data_source.dart';

import 'pin_biometrics_local_datasource_mock.mocks.dart';

@GenerateMocks([PinBiometricsLocalDataSource])
PinBiometricsLocalDataSource pinBiometricsLocalDataSourceMockFactory() => MockPinBiometricsLocalDataSource();