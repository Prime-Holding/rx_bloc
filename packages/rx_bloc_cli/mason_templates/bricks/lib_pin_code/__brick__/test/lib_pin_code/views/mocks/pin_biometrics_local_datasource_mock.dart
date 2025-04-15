import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/data_sources/local/pin_biometrics_local_data_source.dart';

import 'pin_biometrics_local_datasource_mock.mocks.dart';

@GenerateMocks([PinBiometricsLocalDataSource])
PinBiometricsLocalDataSource pinBiometricsLocalDataSourceMockFactory(
    bool showBiometricsButton) {
  final mockPinBiometricsLocalDataSource = MockPinBiometricsLocalDataSource();

  when(mockPinBiometricsLocalDataSource.areBiometricsEnabled())
      .thenAnswer((_) async => showBiometricsButton);

  return mockPinBiometricsLocalDataSource;
}
