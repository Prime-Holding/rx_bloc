{{> licence.dart }}

import 'dart:developer';

import '../../assets.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/repositories/push_notification_repository.dart';{{#enable_feature_onboarding}}
import '../../base/repositories/users_repository.dart';{{/enable_feature_onboarding}}
{{#analytics}}
import '../../lib_analytics/repositories/analytics_repository.dart';
{{/analytics}}
import '../../lib_permissions/services/permissions_service.dart';
import '../models/auth_token_model.dart';
import '../repositories/auth_repository.dart';

class UserAccountService {
  UserAccountService(
    this._authRepository,
    this._pushSubscriptionRepository,{{#enable_feature_onboarding}}
    this._usersRepository,{{/enable_feature_onboarding}}{{#analytics}}
    this._analyticsRepository,{{/analytics}}
    this._permissionsService,
  );

  final AuthRepository _authRepository;
  final PushNotificationRepository _pushSubscriptionRepository;{{#enable_feature_onboarding}}
  final UsersRepository _usersRepository;{{/enable_feature_onboarding}}
  {{#analytics}}
  final AnalyticsRepository _analyticsRepository;
  {{/analytics}}
  final PermissionsService _permissionsService;

  bool _logoutLocked = false;

  /// Checks the user credentials passed in [username] and [password].
  ///
  /// After successful login saves the auth `token` and `refresh token` to
  /// persistent storage and loads the user permissions.
  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw GenericErrorModel(I18nErrorKeys.wrongEmailOrPassword);
    }

    final authToken = await _authRepository.authenticate(
      email: username,
      password: password,
    );{{#enable_feature_onboarding}}

    /// Clear previous data
    await _usersRepository.clearIsProfileTemporary();{{/enable_feature_onboarding}}

    /// Save response tokens
    await saveTokens(authToken);

    /// Subscribe user push token
    await subscribeForNotifications();

    /// Load permissions
    await loadPermissions();

    {{#analytics}}
    // Set user data
    await _analyticsRepository.setUserIdentifier('logged_in_user_id');
    {{/analytics}}
  }

  /// After successful login saves the auth `token` and `refresh token` to
  /// persistent storage.
  Future<void> saveTokens(AuthTokenModel authToken) async {
    await _authRepository.saveToken(authToken.token);
    await _authRepository.saveRefreshToken(authToken.refreshToken);
  }

  /// Subscribe user push token
  Future<void> subscribeForNotifications({bool graceful = true}) async {
    try {
      final notificationsSubscribed =
          await _pushSubscriptionRepository.notificationsSubscribed();

      if (notificationsSubscribed == true) {
        await _pushSubscriptionRepository.subscribeForPushNotifications();
      }
    } catch (e) {
      if (!graceful) {
        rethrow;
      }
      log(e.toString());
    }
  }

  /// Load permissions
  Future<void> loadPermissions({bool graceful = true}) async {
    try {
      await _permissionsService.load();
    } catch (e) {
      if (!graceful) {
        rethrow;
      }
      log(e.toString());
    }
  }

  /// This method logs out the user and delete all stored auth token data.
  ///
  /// After logging out the user it reloads all permissions.
  Future<void> logout() async {
    if (!_logoutLocked) {
      _logoutLocked = true;

      try {
        await _pushSubscriptionRepository.unsubscribeForPushNotifications(true);
      } catch (e) {
        log(e.toString());
      }

      /// Perform user logout
      try {
        await _authRepository.logout();
      } catch (e) {
        log(e.toString());
      }

      /// Clear locally stored auth data
      await _authRepository.clearAuthData();{{#enable_feature_onboarding}}
      await _usersRepository.clearIsProfileTemporary();{{/enable_feature_onboarding}}

      {{#analytics}}
      // Clear analytics identifiers
      await _analyticsRepository.logout();

      {{/analytics}}
      /// Reload user permissions
      await loadPermissions();

      _logoutLocked = false;
    }
  }
}
