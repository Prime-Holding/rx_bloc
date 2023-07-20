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

  Future<bool> setBoolValue(String key, bool value) =>
      _errorMapper.execute(() => _pinCodeDataSource.setBoolValue(key, value));

  Future<bool?> getBoolValue(String key) =>
      _errorMapper.execute(() => _pinCodeDataSource.getBoolValue(key));

  Future<void> writePinToStorage(
    String key,
    String? value,
  ) =>
      _errorMapper.execute(
          () => _pinCodeDataSource.writePinToStorage(key: key, value: value));

  Future<String?> readPinFromStorage({required String key}) => _errorMapper
      .execute(() => _pinCodeDataSource.readPinFromStorage(key: key));

  Future<bool> removeBoolValue(String key) =>
      _errorMapper.execute(() => _pinCodeDataSource.removeBoolValue(key));

  Future<String?> checkIsPinCreated() =>
      _errorMapper.execute(() => _pinCodeDataSource.checkIsPinCreated());

  Future<int> getPinLength() =>
      _errorMapper.execute(() => _pinCodeDataSource.getPinLength());

  Future<String?> getPinCode() =>
      _errorMapper.execute(() => _pinCodeDataSource.getPinCode());
}
