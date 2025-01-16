import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/lib_pin_code/repository/pin_code_repository.dart';
import 'package:{{project_name}}/lib_pin_code/services/verify_pin_code_service.dart';

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
    test('deleteStoredPin should call repository.writePinToStorage with null',
        () async {
      await service.deleteStoredPin();

      verify(repository.writePinToStorage(VerifyPinCodeService.storedPin, null))
          .called(1);
      verify(repository.writePinToStorage(VerifyPinCodeService.firstPin, null))
          .called(1);
    });

    test('deleteSavedData should call repository.writePinToStorage with null',
        () async {
      await service.deleteSavedData();

      verify(repository.writePinToStorage(VerifyPinCodeService.firstPin, null))
          .called(1);
    });

    test('savePinCodeInSecureStorage should return false', () async {
      const pinKey = VerifyPinCodeService.storedPin;
      const pin = Stubs.pin;

      when(repository.writePinToStorage(pinKey, pin))
          .thenAnswer((_) async => pin);

      final result = await service.savePinCodeInSecureStorage(pin);

      expect(result, false);
      verifyNever(repository.writePinToStorage(pinKey, pin));
    });

    test('checkIsPinCreated should return true', () async {
      when(repository.getPinCode()).thenAnswer((_) async => Stubs.pin);

      final result = await service.checkIsPinCreated();

      expect(result, true);
      verify(repository.getPinCode()).called(1);
    });

    test('checkIsPinCreated should return false', () async {
      when(repository.getPinCode()).thenAnswer((_) async => null);

      final result = await service.checkIsPinCreated();

      expect(result, false);
      verify(repository.getPinCode()).called(1);
    });

    test('getPinLength should return pin length', () async {
      const pinLength = Stubs.pin.length;

      when(repository.getPinLength()).thenAnswer((_) async => pinLength);

      final result = await service.getPinLength();

      expect(result, pinLength);
      verify(repository.getPinLength()).called(1);
    });

    test('verifyPinCode should return true', () async {
      const pin = Stubs.pin;

      when(repository.verifyPinCode(pin)).thenAnswer((_) async => pin);

      final result = await service.verifyPinCode(pin);

      expect(result, pin);
      verify(repository.verifyPinCode(pin)).called(1);
    });

    test('getPinCode should return pin', () async {
      const pin = Stubs.pin;

      when(repository.getPinCode()).thenAnswer((_) async => pin);

      final result = await service.getPinCode();

      expect(result, pin);
      verify(repository.getPinCode()).called(1);
    });

    test('getPinCode should return null', () async {
      when(repository.getPinCode()).thenAnswer((_) async => null);

      final result = await service.getPinCode();

      expect(result, null);
      verify(repository.getPinCode()).called(1);
    });
  });
}
