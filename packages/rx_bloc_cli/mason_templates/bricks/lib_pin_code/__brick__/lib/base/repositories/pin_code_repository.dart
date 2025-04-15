{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../base/models/user_model.dart';
import '../data_sources/local/pin_code_local_data_source.dart';
import '../data_sources/remote/pin_code_data_source.dart';
import '../models/pin_code/pin_code_create_request.dart';
import '../models/pin_code/pin_code_update_request.dart';
import '../models/pin_code/pin_code_verify_request.dart';

class PinCodeRepository {
  PinCodeRepository(
    this._errorMapper,
    this._pinCodeLocalDataSource,
    this._pinCodeDataSource,
  );
  final ErrorMapper _errorMapper;
  final PinCodeLocalDataSource _pinCodeLocalDataSource;
  final PinCodeDataSource _pinCodeDataSource;

  /// Store the encrypted pin code in the secure storage
  Future<void> storePin(String encryptedPin) => _errorMapper
      .execute(() => _pinCodeLocalDataSource.storePin(encryptedPin));

  /// Get the locally stored encrypted pin code from the secure storage
  Future<String?> getPinCode() =>
      _errorMapper.execute(() => _pinCodeLocalDataSource.getPin());

  /// Create a new PIN code for the user on the Backend
  Future<UserModel> createPinCode(String pinCode) => _errorMapper.execute(() =>
      _pinCodeDataSource.createPinCode(PinCodeCreateRequest(pinCode: pinCode)));

  Future<int> getPinLength() async => 4;

  /// Verify the PIN code of the user on the Backend
  ///
  /// The response is the token needed for the next step of updating the PIN code.
  Future<String?> verifyPinCode(
    String pinCode, {
    requestUpdateToken = false,
  }) =>
      _errorMapper.execute(
        () async {
          final verifyResponse = await _pinCodeDataSource.verifyPinCode(
            PinCodeVerifyRequest(
              pinCode: pinCode,
              requestUpdateToken: requestUpdateToken,
            ),
          );
          if (requestUpdateToken) {
            return verifyResponse.token;
          }
          return null;
        },
      );

  /// Update the PIN code of the user on the Backend
  ///
  /// The [token] is the one received from the [verifyPinCode] method.
  Future<UserModel> updatePinCode(
    String pinCode, {
    required String token,
  }) =>
      _errorMapper.execute(
        () => _pinCodeDataSource.updatePinCode(
          PinCodeUpdateRequest(pinCode: pinCode, token: token),
        ),
      );
}