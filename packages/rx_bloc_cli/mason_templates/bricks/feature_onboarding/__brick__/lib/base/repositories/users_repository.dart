{{> licence.dart }}

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/users_local_data_source.dart';
import '../data_sources/remote/users_remote_data_source.dart';
import '../models/credentials_model.dart';
import '../models/request_models/confirm_email_model.dart';
import '../models/user_model.dart';
import '../models/user_with_auth_token_model.dart';

class UsersRepository {
  UsersRepository(
    this._errorMapper,
    this._usersLocalDataSource,
    this._usersRemoteDataSource,
  );

  final ErrorMapper _errorMapper;
  final UsersLocalDataSource _usersLocalDataSource;
  final UsersRemoteDataSource _usersRemoteDataSource;

  /// Starts the onboarding for a new user with the given [email] and [password].
  /// Returns the [UserModel] with the email and temporary profile, as well as
  /// their access token
  Future<UserWithAuthTokenModel> register({
    required String email,
    required String password,
  }) =>
      _errorMapper.execute(
        () => _usersRemoteDataSource.register(
          CredentialsModel(
            email: email,
            password: password,
          ),
        ),
      );

  /// Gets the existing user. Currently used to resume onboarding
  Future<UserModel> getMyUser() => _errorMapper.execute(
        () => _usersRemoteDataSource.getMyUser(),
      );

  /// Resends the confirmation email to the user
  Future<UserModel> resendConfirmationEmail() => _errorMapper.execute(
        () => _usersRemoteDataSource.resendConfirmationEmail(),
      );

  /// Confirms the email of the user with the given [token].
  /// Returns the [UserModel] with the confirmed email
  Future<UserModel> confirmEmail({
    required String token,
  }) =>
      _errorMapper.execute(
        () => _usersRemoteDataSource.confirmEmail(ConfirmEmailModel(token)),
      );

  /// Returns true if the profile is temporary, during onboarding
  Future<bool> isProfileTemporary() =>
      _errorMapper.execute(() => _usersLocalDataSource.isProfileTemporary());

  /// Sets the profile as temporary, during onboarding
  Future<void> setIsProfileTemporary(bool isProfileTemporary) =>
      _errorMapper.execute(
        () => _usersLocalDataSource.setIsProfileTemporary(isProfileTemporary),
      );

  /// Clears the temporary profile, after finished onboarding
  Future<void> clearIsProfileTemporary() => _errorMapper
      .execute(() => _usersLocalDataSource.clearIsProfileTemporary());
}
