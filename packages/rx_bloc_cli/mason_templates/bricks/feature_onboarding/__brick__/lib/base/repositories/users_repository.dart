{{> licence.dart }}

import '../../base/models/request_models/phone_number_request_model.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/users_remote_data_source.dart';
import '../models/request_models/change_email_request_model.dart';
import '../models/request_models/confirm_email_model.dart';
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
  
  /// Initiates the email change process with the new email
  /// New user is created with a temporary role
  Future<UserModel> changeEmail(String email) => _errorMapper.execute(
        () => _usersRemoteDataSource
            .changeEmail(ChangeEmailRequestModel(email: email)),
      );

  /// Confirms the new email of the user and updates the user's role from temporary
  /// to the user role, deletes the old user with the user role
  Future<UserModel> confirmEmail(String token) => _errorMapper.execute(
        () => _usersRemoteDataSource.confirmEmail(ConfirmEmailModel(token)),
      );

  /// Resends the confirmation email to the user
  Future<UserModel> resendConfirmationEmail() => _errorMapper.execute(
        () => _usersRemoteDataSource.resendConfirmationEmail(),
      );
}
