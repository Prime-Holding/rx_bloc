import '../repositories/pin_code_repository.dart';
import '../utils/server_exceptions.dart';
import '../utils/utilities.dart';

class PinCodeService {
  const PinCodeService(this._pinCodeRepository);

  final PinCodeRepository _pinCodeRepository;

  bool savePinCode(String userId, String pinCode) =>
      _pinCodeRepository.savePinCode(userId, pinCode);

  String? getPinCode(String userId) => _pinCodeRepository.getPinCode(userId);

  bool verifyPinCode(String userId, String pinCode) {
    final savedPinCode = getPinCode(userId);
    if (savedPinCode == null) {
      throw UnprocessableEntityException('Missing PIN code');
    }
    if (savedPinCode != pinCode) {
      throw UnprocessableEntityException('Incorrect PIN code');
    }
    return true;
  }

  String generateUpdateToken(String userId) {
    final token = generateRandomString();
    _pinCodeRepository.saveToken(userId, token);
    return token;
  }

  bool verifyUpdateToken(String userId, String token) {
    final savedToken = _pinCodeRepository.getToken(userId);
    if (savedToken == null) {
      throw UnprocessableEntityException('Missing update token');
    }
    if (savedToken != token) {
      throw UnprocessableEntityException('Incorrect update token');
    }
    return true;
  }

  bool removeToken(String userId) => _pinCodeRepository.deleteToken(userId);
}
