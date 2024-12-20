{{> licence.dart }}

import '../../base/models/request_models/confirm_phone_number_request_model.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/register_remote_data_source.dart';
import '../models/credentials_model.dart';
import '../models/request_models/confirm_email_model.dart';
import '../models/user_model.dart';
import '../models/user_with_auth_token_model.dart';

class RegisterRepository {
  RegisterRepository(
    this._errorMapper,
    this._registerRemoteDataSource,
  );

  final ErrorMapper _errorMapper;
  final RegisterRemoteDataSource _registerRemoteDataSource;

  /// Starts the onboarding for a new user with the given [email] and [password].
  /// Returns the [UserModel] with the email and temporary profile, as well as
  /// their access token
  Future<UserWithAuthTokenModel> register({
    required String email,
    required String password,
  }) =>
      _errorMapper.execute(
        () => _registerRemoteDataSource.register(
          CredentialsModel(
            email: email,
            password: password,
          ),
        ),
      );

  /// Resends the confirmation email to the user
  Future<UserModel> resendConfirmationEmail() => _errorMapper.execute(
        () => _registerRemoteDataSource.resendConfirmationEmail(),
      );

  /// Confirms the email of the user with the given [token].
  /// Returns the [UserModel] with the confirmed email
  Future<UserModel> confirmEmail({
    required String token,
  }) =>
      _errorMapper.execute(
        () => _registerRemoteDataSource.confirmEmail(ConfirmEmailModel(token)),
      );

  /// Confirms the phone number for the user by providing the SMS code sent to
  /// the user's phone number.
  Future<UserModel> confirmPhoneNumber(String smsCode) => _errorMapper.execute(
        () => _registerRemoteDataSource.confirmPhoneNumber(
            ConfirmPhoneNumberRequestModel(smsCode: smsCode)),
      );

  /// Resends the SMS code to the user's phone number
  Future<void> resendSmsCode() => _errorMapper.execute(
        () => _registerRemoteDataSource.resendSmsCode(),
      );
}
