{{> licence.dart }}

import '../common_mappers/error_mappers/error_mapper.dart';
import '../../base/data_sources/remote/users_remote_data_source.dart';
import '../../base/models/request_models/confirm_phone_number_request_model.dart';
import '../../base/models/request_models/phone_number_request_model.dart';
import '../../base/models/user_model.dart';

class UsersRepository {
  UsersRepository(
    this._errorMapper,
    this._usersRemoteDataSource,
  );

  final ErrorMapper _errorMapper;
  final UsersRemoteDataSource _usersRemoteDataSource;

  /// Sets the phone number for the user. At this point, the user has not yet
  /// confirmed the phone number and his account type is still marked as with a
  /// temporary role.
  Future<UserModel> submitPhoneNumber(String phoneNumber) =>
      _errorMapper.execute(
        () => _usersRemoteDataSource.submitPhoneNumber(
            PhoneNumberRequestModel(phoneNumber: phoneNumber)),
      );

  /// Confirms the phone number for the user by providing the SMS code sent to
  /// the user's phone number.
  Future<UserModel> confirmPhoneNumber(String smsCode) => _errorMapper.execute(
        () => _usersRemoteDataSource.confirmPhoneNumber(
            ConfirmPhoneNumberRequestModel(smsCode: smsCode)),
      );

  /// Resends the SMS code to the user's phone number
  Future<void> resendSmsCode() => _errorMapper.execute(
        () => _usersRemoteDataSource.resendSmsCode(),
      );
}
