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

  Future<UserModel> getMyUser() => _errorMapper.execute(
        () => _usersRemoteDataSource.getMyUser(),
      );

  Future<UserModel> resendConfirmationEmail() => _errorMapper.execute(
        () => _usersRemoteDataSource.resendConfirmationEmail(),
      );

  Future<UserModel> confirmEmail({
    required String token,
  }) =>
      _errorMapper.execute(
        () => _usersRemoteDataSource.confirmEmail(ConfirmEmailModel(token)),
      );

  Future<bool> isProfileTemporary() =>
      _errorMapper.execute(() => _usersLocalDataSource.isProfileTemporary());

  Future<void> setIsProfileTemporary(bool isProfileTemporary) =>
      _errorMapper.execute(
        () => _usersLocalDataSource.setIsProfileTemporary(isProfileTemporary),
      );

  Future<void> clearIsProfileTemporary() => _errorMapper
      .execute(() => _usersLocalDataSource.clearIsProfileTemporary());
}
