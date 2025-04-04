{{> licence.dart }}

import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../base/repositories/pin_code_repository.dart';

class VerifyPinCodeService implements PinCodeService {
  VerifyPinCodeService(this.pinCodeRepository);

  final PinCodeRepository pinCodeRepository;

  @override
  Future<bool> savePinCodeInSecureStorage(String pinCode) async => false;

  ///TODO: Implement encryption
  @override
  Future<String> encryptPinCode(String pinCode) async => pinCode;

  @override
  Future<int> getPinLength() => pinCodeRepository.getPinLength();
  @override
  Future<String?> verifyPinCode(String pinCode) async =>
      pinCodeRepository.verifyPinCode(pinCode);
  @override
  Future<String?> getPinCode() => pinCodeRepository.getPinCode();
}