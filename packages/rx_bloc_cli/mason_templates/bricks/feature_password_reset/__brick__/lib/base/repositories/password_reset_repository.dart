{{> licence.dart }}

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/password_reset_remote_data_source.dart';
import '../models/request_models/password_reset_init_request_model.dart';
import '../models/request_models/password_reset_request_model.dart';

class PasswordResetRepository {
  PasswordResetRepository(
    this._errorMapper,
    this._passwordResetRemoteDataSource,
  );

  final ErrorMapper _errorMapper;
  final PasswordResetRemoteDataSource _passwordResetRemoteDataSource;

  /// Requests a password reset for the user
  Future<void> requestPasswordReset(String email) => _errorMapper.execute(
        () => _passwordResetRemoteDataSource
            .requestPasswordReset(PasswordResetInitRequestModel(email)),
      );

  /// Resets the user's password
  Future<void> resetPassword(String token, String password) =>
      _errorMapper.execute(
        () => _passwordResetRemoteDataSource.resetPassword(
          PasswordResetRequestModel(token, password),
        ),
      );
}
