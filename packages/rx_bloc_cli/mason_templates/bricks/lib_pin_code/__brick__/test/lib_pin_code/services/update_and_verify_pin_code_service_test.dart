import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/lib_pin_code/repository/pin_code_repository.dart';
import 'package:{{project_name}}/lib_pin_code/services/update_and_verify_pin_code_service.dart';

import '../stubs.dart';
import 'update_and_verify_pin_code_service_test.mocks.dart';

@GenerateMocks([PinCodeRepository])
void main() {
  late MockPinCodeRepository repository;
  late UpdateAndVerifyPinCodeService service;

  setUp(() {
    repository = MockPinCodeRepository();
    service = UpdateAndVerifyPinCodeService(repository);
  });

  tearDown(() {
    reset(repository);
  });

  group('UpdateAndVerifyPinCodeService', () {
    test('deleteStoredPin should call repository.writePinToStorage with null',
        () async {
      await service.deleteStoredPin();

      verify(repository.writePinToStorage(Stubs.storedPinKey, null)).called(1);
      verify(repository.writePinToStorage(Stubs.firstPinKey, null)).called(1);
    });

    test('deleteSavedData should call repository.writePinToStorage with null',
        () async {
      await service.deleteSavedData();

      verify(repository.writePinToStorage(Stubs.firstPinKey, null)).called(1);
    });

    test('isPinCodeInSecureStorage should return true', () async {
      const pinKey = Stubs.storedPinKey;
      const pin = Stubs.pin;

      when(repository.readPinFromStorage(key: pinKey)).thenAnswer((_) async => pin);

      final result = await service.isPinCodeInSecureStorage();

      expect(result, true);
      verify(repository.readPinFromStorage(key: pinKey)).called(1);
    });

    test('isPinCodeInSecureStorage should return false', () async {
      const pinKey = Stubs.storedPinKey;

      when(repository.readPinFromStorage(key: pinKey)).thenAnswer((_) async => null);

      final result = await service.isPinCodeInSecureStorage();

      expect(result, false);
      verify(repository.readPinFromStorage(key: pinKey)).called(1);
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
      const pinLength  = Stubs.pin.length;

      when(repository.getPinLength()).thenAnswer((_) async => pinLength);

      final result = await service.getPinLength();

      expect(result, pinLength);
      verify(repository.getPinLength()).called(1);
    });

    test('verifyPinCode should return true', () async {
      const pin  = Stubs.pin;
      const storedPinKey  = Stubs.storedPinKey;
      const firstPinKey  = Stubs.firstPinKey;

      when(repository.readPinFromStorage(key: storedPinKey)).thenAnswer((_) async => pin);
      when(repository.readPinFromStorage(key: firstPinKey)).thenAnswer((_) async => pin);

      final result = await service.verifyPinCode(pin);

      expect(result, true);
      verify(repository.readPinFromStorage(key: storedPinKey)).called(1);
      verify(repository.readPinFromStorage(key: firstPinKey)).called(1);
    });

    test('verifyPinCode should return false', () async {
      const storedPinKey  = Stubs.storedPinKey;
      const firstPinKey  = Stubs.firstPinKey;

      when(repository.readPinFromStorage(key: storedPinKey)).thenAnswer((_) async => null);
      when(repository.readPinFromStorage(key: firstPinKey)).thenAnswer((_) async => null);

      final result = await service.verifyPinCode(Stubs.pin);

      expect(result, false);
      verify(repository.readPinFromStorage(key: storedPinKey)).called(1);
      verify(repository.readPinFromStorage(key: firstPinKey)).called(1);
    });

    test('getPinCode should return pin', () async {
      const pin  = Stubs.pin;

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
