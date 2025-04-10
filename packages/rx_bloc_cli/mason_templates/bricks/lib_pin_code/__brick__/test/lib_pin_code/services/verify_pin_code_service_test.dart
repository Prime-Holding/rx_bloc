import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/repositories/pin_code_repository.dart';
import 'package:{{project_name}}/feature_pin_code/services/verify_pin_code_service.dart';

import '../stubs.dart';
import 'verify_pin_code_service_test.mocks.dart';

@GenerateMocks([PinCodeRepository])
void main() {
  late MockPinCodeRepository repository;
  late VerifyPinCodeService service;

  setUp(() {
    repository = MockPinCodeRepository();
    service = VerifyPinCodeService(repository);
  });

  tearDown(() {
    reset(repository);
  });

  group('VerifyPinCodeService', () {
    test('savePinCodeInSecureStorage should return false', () async {
      final result = await service.savePinCodeInSecureStorage(Stubs.pin);
      expect(result, false);
    });

    test('encryptPinCode should return the same pin code', () async {
      final result = await service.encryptPinCode(Stubs.pin);
      expect(result, Stubs.pin);
    });

    test('getPinLength should return pin length from repository', () async {
      const pinLength = Stubs.pin.length;

      when(repository.getPinLength()).thenAnswer((_) async => pinLength);

      final result = await service.getPinLength();

      expect(result, pinLength);
      verify(repository.getPinLength()).called(1);
    });

    test('verifyPinCode should call repository.verifyPinCode', () async {
      const pin = Stubs.pin;
      final expectedResult = 'verify_token';

      when(repository.verifyPinCode(pin))
          .thenAnswer((_) async => expectedResult);

      final result = await service.verifyPinCode(pin);

      expect(result, expectedResult);
      verify(repository.verifyPinCode(pin)).called(1);
    });

    test('getPinCode should return pin from repository', () async {
      const pin = Stubs.pin;

      when(repository.getPinCode()).thenAnswer((_) async => pin);

      final result = await service.getPinCode();

      expect(result, pin);
      verify(repository.getPinCode()).called(1);
    });

    test('getPinCode should return null when repository returns null',
        () async {
      when(repository.getPinCode()).thenAnswer((_) async => null);

      final result = await service.getPinCode();

      expect(result, null);
      verify(repository.getPinCode()).called(1);
    });
  });
}
