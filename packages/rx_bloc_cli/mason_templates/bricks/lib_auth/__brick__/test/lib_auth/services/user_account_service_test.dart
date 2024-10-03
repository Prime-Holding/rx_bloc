import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/repositories/push_notification_repository.dart';
import 'package:{{project_name}}/lib_analytics/repositories/analytics_repository.dart';
import 'package:{{project_name}}/lib_auth/repositories/auth_repository.dart';
import 'package:{{project_name}}/lib_auth/services/user_account_service.dart';
import 'package:{{project_name}}/lib_permissions/services/permissions_service.dart';

import '../stubs.dart';
import 'user_account_service_test.mocks.dart';

@GenerateMocks([
  AuthRepository,
  PushNotificationRepository,
  AnalyticsRepository,
  PermissionsService
])
void main() {
  late MockAuthRepository authRepository;
  late MockPushNotificationRepository pushNotificationRepository;
  late MockAnalyticsRepository analyticsRepository;
  late MockPermissionsService permissionsService;

  late UserAccountService userAccountService;

  setUp(() {
    authRepository = MockAuthRepository();
    pushNotificationRepository = MockPushNotificationRepository();
    analyticsRepository = MockAnalyticsRepository();
    permissionsService = MockPermissionsService();
    userAccountService = UserAccountService(authRepository,
        pushNotificationRepository, analyticsRepository, permissionsService);
  });

  tearDown(() {
    reset(authRepository);
    reset(pushNotificationRepository);
    reset(analyticsRepository);
    reset(permissionsService);
  });

  group('UserAccountService', () {
    test('login should call saveTokens', () async {
      const email = Stubs.email;
      const password = Stubs.password;
      final authTokenModel = Stubs.authTokenModel;

      when(authRepository.authenticate(email: email, password: password))
          .thenAnswer((_) async => authTokenModel);

      await userAccountService.login(username: email, password: password);

      verify(authRepository.authenticate(email: email, password: password))
          .called(1);
      verify(userAccountService.saveTokens(authTokenModel)).called(1);
      verify(userAccountService.subscribeForNotifications()).called(1);
      verify(userAccountService.loadPermissions()).called(1);
      verify(analyticsRepository.setUserIdentifier('logged_in_user_id'))
          .called(1);
    });

    test('saveTokens should call repository saveToken and saveRefreshToken',
        () async {
      final authTokenModel = Stubs.authTokenModel;

      await userAccountService.saveTokens(authTokenModel);

      verify(authRepository.saveToken(authTokenModel.token)).called(1);
      verify(authRepository.saveRefreshToken(authTokenModel.refreshToken))
          .called(1);
    });

    test(
        'subscribeForNotifications should call repository subscribeForPushNotifications',
        () async {
      when(pushNotificationRepository.notificationsSubscribed())
          .thenAnswer((_) async => true);

      await userAccountService.subscribeForNotifications();

      verify(pushNotificationRepository.subscribeForPushNotifications())
          .called(1);
    });

    test(
        'subscribeForNotifications should not call repository subscribeForPushNotifications',
        () async {
      when(pushNotificationRepository.notificationsSubscribed())
          .thenAnswer((_) async => false);

      await userAccountService.subscribeForNotifications();

      verifyNever(pushNotificationRepository.subscribeForPushNotifications());
    });

    test('loadPermissions should call repository load', () async {
      await userAccountService.loadPermissions();

      verify(permissionsService.load()).called(1);
    });

    test('logout when user was logged in', () async {
      await userAccountService.logout();

      verify(pushNotificationRepository.unsubscribeForPushNotifications(true)).called(1);
      verify(authRepository.logout()).called(1);
      verify(authRepository.clearAuthData()).called(1);
      verify(analyticsRepository.logout()).called(1);
      verify(userAccountService.loadPermissions()).called(1);
    });
  });
}
