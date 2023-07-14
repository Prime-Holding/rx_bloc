{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_source/pin_code_data_source.dart';

class PinCodeRepository {
  PinCodeRepository(
    this._errorMapper,
    this._pinCodeDataSource,
  );

  final ErrorMapper _errorMapper;

  final PinCodeDataSource _pinCodeDataSource;

  Future<void> deleteStoredPin() =>
      _errorMapper.execute(() => _pinCodeDataSource.deleteStoredPin());

  Future<void> deleteSavedData() =>
      _errorMapper.execute(() => _pinCodeDataSource.deleteSavedData());

  Future<bool> setPinCodeType(bool isFromSessionTimeout) => _errorMapper
      .execute(() => _pinCodeDataSource.setPinCodeType(isFromSessionTimeout));

  Future<bool> isPinCodeInSecureStorage() =>
      _errorMapper.execute(() => _pinCodeDataSource.isPinCodeInSecureStorage());

  Future<bool> checkIsPinCreated() =>
      _errorMapper.execute(() => _pinCodeDataSource.checkIsPinCreated());

  Future<String> encryptPinCode(String pinCode) =>
      _errorMapper.execute(() => _pinCodeDataSource.encryptPinCode(pinCode));

  Future<int> getPinLength() =>
      _errorMapper.execute(() => _pinCodeDataSource.getPinLength());

  Future<bool> verifyPinCode(String pinCode) =>
      _errorMapper.execute(() => _pinCodeDataSource.verifyPinCode(pinCode));

  Future<String?> getPinCode() =>
      _errorMapper.execute(() => _pinCodeDataSource.getPinCode());
}
