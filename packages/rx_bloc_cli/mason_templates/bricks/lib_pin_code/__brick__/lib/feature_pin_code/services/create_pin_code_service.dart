{{> licence.dart }}

import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../assets.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/pin_code/create_pin_model.dart';
import '../../base/repositories/pin_code_repository.dart';

class CreatePinCodeService implements PinCodeService {
  CreatePinCodeService(
    this._pinCodeRepository,
    this._createPinModel,
  );

  final CreatePinModel _createPinModel;
  final PinCodeRepository _pinCodeRepository;

  @override
  Future<CreatePinModel?> verifyPinCode(String pinCode) async {
    if (_createPinModel case CreatePinSetModel()) {
      return CreatePinConfirmModel(pinToConfirm: pinCode);
    }

    if (_createPinModel
        case CreatePinConfirmModel(pinToConfirm: String pinToConfirm)) {
      return _createPinCode(pinCode, pinToConfirm);
    }

    return null;
  }

  Future<CreatePinModel> _createPinCode(String pinCode, String pinToConfirm) {
    if (pinCode != pinToConfirm) {
      throw GenericErrorModel(I18nErrorKeys.wrongPin);
    }

    // If the pin code is the same we save it
    return _pinCodeRepository
        .createPinCode(pinCode)
        .then((user) => CreatePinCompleteModel(user: user));
  }

  @override
  Future<bool> savePinCodeInSecureStorage(String pinCode) async => false;

  ///TODO: Implement encryption
  @override
  Future<String> encryptPinCode(String pinCode) async => pinCode;

  @override
  Future<int> getPinLength() async => 4;

  @override
  Future<String?> getPinCode() async => null;
}