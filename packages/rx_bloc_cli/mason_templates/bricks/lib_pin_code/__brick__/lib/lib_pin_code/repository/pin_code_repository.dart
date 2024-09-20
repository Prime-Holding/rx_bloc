{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_source/pin_code_local_data_source.dart';
import '../data_source/remote/pin_code_data_source.dart';
import '../models/pin_code_create_request.dart';
import '../models/pin_code_update_request.dart';
import '../models/pin_code_verify_request.dart';

class PinCodeRepository {
  PinCodeRepository(
    this._errorMapper,
    this._pinCodeLocalDataSource,
    this._pinCodeDataSource,
  );

  final ErrorMapper _errorMapper;
  final PinCodeLocalDataSource _pinCodeLocalDataSource;
  final PinCodeDataSource _pinCodeDataSource;

  Future<void> writePinToStorage(
    String key,
    String? value,
  ) =>
      _errorMapper.execute(() =>
          _pinCodeLocalDataSource.writePinToStorage(key: key, value: value));

  Future<String?> readPinFromStorage({required String key}) => _errorMapper
      .execute(() => _pinCodeLocalDataSource.readPinFromStorage(key: key));

  Future<int> getPinLength() =>
      _errorMapper.execute(() => _pinCodeLocalDataSource.getPinLength());

  Future<String?> getPinCode() =>
      _errorMapper.execute(() => _pinCodeLocalDataSource.getPinCode());

  /// Create a new PIN code for the user on the Backend
  Future<void> createPinCode(String pinCode) => _errorMapper.execute(
        () => _pinCodeDataSource.createPinCode(
          PinCodeCreateRequest(pinCode: pinCode),
        ),
      );

  /// Verify the PIN code of the user on the Backend
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
  Future<void> updatePinCode(
    String pinCode,
    String token,
  ) => _errorMapper.execute(
        () => _pinCodeDataSource.updatePinCode(
          PinCodeUpdateRequest(pinCode: pinCode, token: token),
        ),
      );
}
