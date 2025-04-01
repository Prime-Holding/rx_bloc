import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/models/user_model.dart';
import 'package:{{project_name}}/feature_pin_code/models/create_pin_model.dart';
import 'package:{{project_name}}/feature_pin_code/repository/pin_code_repository.dart';
import 'package:{{project_name}}/feature_pin_code/services/create_pin_code_service.dart';

import '../stubs.dart';
import 'create_pin_code_service_test.mocks.dart';

@GenerateMocks([PinCodeRepository])
void main() {
  late MockPinCodeRepository repository;
  late CreatePinCodeService createPinService;

  setUp(() {
    repository = MockPinCodeRepository();
    createPinService = CreatePinCodeService(repository, CreatePinSetModel());
  });

  tearDown(() {
    reset(repository);
  });

  group('CreatePinCodeService', () {
    test(
        'verifyPinCode should return CreatePinConfirmModel when set model is provided',
        () async {
      final result = await createPinService.verifyPinCode(Stubs.pin);

      expect(result, isA<CreatePinConfirmModel>());
      expect((result as CreatePinConfirmModel).pinToConfirm, Stubs.pin);
    });

    test('verifyPinCode should call repository.createPinCode when pin matches',
        () async {
      // First set up the model to have a pinToConfirm
      final createPinService = CreatePinCodeService(
          repository, CreatePinConfirmModel(pinToConfirm: Stubs.pin));

      when(repository.createPinCode(Stubs.pin))
          .thenAnswer((_) async => UserModel.tempUser());

      final result = await createPinService.verifyPinCode(Stubs.pin);

      expect(result, isA<CreatePinCompleteModel>());
      verify(repository.createPinCode(Stubs.pin)).called(1);
    });

    test('getPinLength should return length from repository', () async {
      const pinLength = Stubs.pin.length;

      when(repository.getPinLength()).thenAnswer((_) async => pinLength);

      final result = await createPinService.getPinLength();

      expect(result, pinLength);
    });

    test('getPinCode should return null', () async {
      final result = await createPinService.getPinCode();

      expect(result, null);
    });

    test('savePinCodeInSecureStorage should return false', () async {
      final result =
          await createPinService.savePinCodeInSecureStorage(Stubs.pin);

      expect(result, false);
    });

    test('encryptPinCode should return the same pin code', () async {
      final result = await createPinService.encryptPinCode(Stubs.pin);

      expect(result, Stubs.pin);
    });
  });
}
