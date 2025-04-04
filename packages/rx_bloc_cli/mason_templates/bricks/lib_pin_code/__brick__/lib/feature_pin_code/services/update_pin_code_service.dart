{{> licence.dart }}

import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../assets.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/pin_code/update_pin_model.dart';
import '../../base/repositories/pin_code_repository.dart';

class UpdatePinCodeService implements PinCodeService {
  UpdatePinCodeService(
    this._pinCodeRepository,
    this._updatePinModel,
  );

  final UpdatePinModel _updatePinModel;
  final PinCodeRepository _pinCodeRepository;

  @override
  Future<UpdatePinModel?> verifyPinCode(String pinCode) async {
    // 1. Verify the pin code and return the next state
    if (_updatePinModel case UpdatePinVerifyModel()) {
      return _pinCodeRepository
          .verifyPinCode(pinCode, requestUpdateToken: true)
          .then((token) => UpdatePinSetModel(token: token!));
    }

    // 2. Set the pin code and return the next state
    if (_updatePinModel case UpdatePinSetModel(token: String token)) {
      return UpdatePinConfirmModel(pinToConfirm: pinCode, token: token);
    }

    // 3. Confirm the pin code and complete the flow
    if (_updatePinModel
        case UpdatePinConfirmModel(
          pinToConfirm: String pinToConfirm,
          token: String token,
        )) {
      if (pinCode != pinToConfirm) {
        throw GenericErrorModel(I18nErrorKeys.wrongPin);
      }

      // If the pin code is the same we save it
      return _pinCodeRepository
          .updatePinCode(pinCode, token: token)
          .then((user) => UpdatePinCompleteModel(user: user));
    }

    return null;
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