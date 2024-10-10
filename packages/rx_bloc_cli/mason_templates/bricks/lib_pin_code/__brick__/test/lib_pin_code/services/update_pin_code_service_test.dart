import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/lib_pin_code/repository/pin_code_repository.dart';
import 'package:{{project_name}}/lib_pin_code/services/update_pin_code_service.dart';
import 'package:{{project_name}}/lib_pin_code/services/verify_pin_code_service.dart';

import '../stubs.dart';
import 'update_pin_code_service_test.mocks.dart';

@GenerateMocks([PinCodeRepository])
void main() {
  late MockPinCodeRepository repository;
  late UpdatePinCodeService service;

  setUp(() {
    repository = MockPinCodeRepository();
    service = UpdatePinCodeService(repository);
  });

  tearDown(() {
    reset(repository);
  });

  group('UpdatePinCodeService', () {
    test('verifyPinCode should return null', () async {
      const pin = Stubs.pin;
      const storedPinKey = VerifyPinCodeService.storedPin;
      const firstPinKey = VerifyPinCodeService.firstPin;

      when(repository.readPinFromStorage(key: firstPinKey))
          .thenAnswer((_) async => pin);
      when(repository.readPinFromStorage(key: storedPinKey))
          .thenAnswer((_) async => pin);

      final result = await service.verifyPinCode(pin);

      expect(result, null);
      verify(repository.readPinFromStorage(key: firstPinKey)).called(1);
      verify(repository.updatePinCode(pin, '')).called(1);
      verify(repository.writePinToStorage(storedPinKey, pin)).called(1);
    });

    test('verifyPinCode should return null', () async {
      const pin = Stubs.pin;
      const storedPinKey = VerifyPinCodeService.storedPin;
      const firstPinKey = VerifyPinCodeService.firstPin;

      when(repository.readPinFromStorage(key: firstPinKey))
          .thenAnswer((_) async => pin);
      when(repository.readPinFromStorage(key: storedPinKey))
          .thenAnswer((_) async => pin);

      final result = await service.verifyPinCode(pin);

      expect(result, null);
      verify(repository.readPinFromStorage(key: firstPinKey)).called(1);
      verify(repository.updatePinCode(pin, '')).called(1);
      verify(repository.writePinToStorage(storedPinKey, pin)).called(1);
    });
  });
}
