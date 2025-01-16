{{> licence.dart }}

import '../../base/models/request_models/phone_number_request_model.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/users_remote_data_source.dart';
import '../models/user_model.dart';

class UsersRepository {
  UsersRepository(
    this._errorMapper,
    this._usersRemoteDataSource,
  );

  final ErrorMapper _errorMapper;
  final UsersRemoteDataSource _usersRemoteDataSource;

  /// Gets the existing user. Currently used to resume onboarding
  Future<UserModel> getMyUser() => _errorMapper.execute(
        () => _usersRemoteDataSource.getMyUser(),
      );

  /// Sets the phone number for the user. At this point, the user has not yet
  /// confirmed the phone number and his account type is still marked as with a
  /// temporary role.
  Future<UserModel> submitPhoneNumber(String phoneNumber) =>
      _errorMapper.execute(
        () => _usersRemoteDataSource.submitPhoneNumber(
            PhoneNumberRequestModel(phoneNumber: phoneNumber)),
      );
}
