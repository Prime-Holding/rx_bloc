import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/models/pin_code/update_pin_model.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/base/repositories/pin_code_repository.dart';
import 'package:{{project_name}}/feature_pin_code/services/update_pin_code_service.dart';

import '../stubs.dart';
import 'update_pin_code_service_test.mocks.dart';

@GenerateMocks([PinCodeRepository])
void main() {
  late MockPinCodeRepository repository;
  late UpdatePinCodeService service;

  setUp(() {
    repository = MockPinCodeRepository();
  });

  tearDown(() {
    reset(repository);
  });

  group('UpdatePinCodeService', () {
    test(
        'verifyPinCode should verify pin and return UpdatePinSetModel when in verify state',
        () async {
      const pin = Stubs.pin;
      final token = 'update_token';

      // Start with verify state
      service = UpdatePinCodeService(repository, UpdatePinVerifyModel());

      // Mock verifyPinCode to return a token
      when(repository.verifyPinCode(pin, requestUpdateToken: true))
          .thenAnswer((_) async => token);

      final result = await service.verifyPinCode(pin);

      expect(result, isA<UpdatePinSetModel>());
      expect((result as UpdatePinSetModel).token, token);
      verify(repository.verifyPinCode(pin, requestUpdateToken: true)).called(1);
    });

    test('verifyPinCode should return UpdatePinConfirmModel when in set state',
        () async {
      const pin = Stubs.pin;
      final token = 'update_token';

      // Start with set state
      service =
          UpdatePinCodeService(repository, UpdatePinSetModel(token: token));

      final result = await service.verifyPinCode(pin);

      expect(result, isA<UpdatePinConfirmModel>());
      expect((result as UpdatePinConfirmModel).pinToConfirm, pin);
      expect(result.token, token);
    });

    test(
        'verifyPinCode should update pin and return UpdatePinCompleteModel when in confirm state',
        () async {
      const pin = Stubs.pin;
      final token = 'update_token';

      // Start with confirm state
      service = UpdatePinCodeService(
          repository, UpdatePinConfirmModel(pinToConfirm: pin, token: token));

      // Mock updatePinCode to return a user
      when(repository.updatePinCode(pin, token: token))
          .thenAnswer((_) async => UserModel.tempUser());

      final result = await service.verifyPinCode(pin);

      expect(result, isA<UpdatePinCompleteModel>());
      verify(repository.updatePinCode(pin, token: token)).called(1);
    });

    test('getPinLength should return length from repository', () async {
      const pinLength = Stubs.pin.length;
      service = UpdatePinCodeService(repository, UpdatePinVerifyModel());

      when(repository.getPinLength()).thenAnswer((_) async => pinLength);

      final result = await service.getPinLength();

      expect(result, pinLength);
    });

    test('encryptPinCode should return the same pin code', () async {
      service = UpdatePinCodeService(repository, UpdatePinVerifyModel());
      final result = await service.encryptPinCode(Stubs.pin);

      expect(result, Stubs.pin);
    });

    test('savePinCodeInSecureStorage should return false', () async {
      service = UpdatePinCodeService(repository, UpdatePinVerifyModel());
      final result = await service.savePinCodeInSecureStorage(Stubs.pin);

      expect(result, false);
    });
  });
}
