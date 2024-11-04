import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/lib_pin_code/repository/pin_biometrics_repository.dart';
import 'package:{{project_name}}/lib_pin_code/services/pin_biometrics_service.dart';

import 'pin_biometrics_service_test.mocks.dart';

@GenerateMocks([PinBiometricsRepository])
void main() {
  late MockPinBiometricsRepository repository;
  late PinBiometricsService service;

  setUp(() {
    repository = MockPinBiometricsRepository();
    service = PinBiometricsService(repository);
  });

  tearDown(() {
    reset(repository);
  });

  Future<void> areBiometricsEnabledTest(bool expectedResult) async {
    when(repository.areBiometricsEnabled())
        .thenAnswer((_) async => expectedResult);

    final result = await service.areBiometricsEnabled();

    expect(result, expectedResult);
    verify(repository.areBiometricsEnabled()).called(1);
  }

  Future<void> setBiometricsEnabledTest(bool shouldEnableBiometrics) async {
    await service.setBiometricsEnabled(shouldEnableBiometrics);

    verify(repository.setBiometricsEnabled(shouldEnableBiometrics)).called(1);
  }

  group('PinBiometricsService', () {
    test(
        'areBiometricsEnabled should call repository.areBiometricsEnabled and return true',
        () async {
      await areBiometricsEnabledTest(true);
    });

    test(
        'areBiometricsEnabled should call repository.areBiometricsEnabled and return false',
        () async {
      await areBiometricsEnabledTest(false);
    });

    test(
        'setBiometricsEnabled should call repository.setBiometricsEnabled with true',
        () async {
      await setBiometricsEnabledTest(true);
    });

    test(
        'setBiometricsEnabled should call repository.setBiometricsEnabled with true',
        () async {
      await setBiometricsEnabledTest(false);
    });
  });
}
