import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';
import 'package:{{project_name}}/lib_auth/blocs/user_account_bloc.dart';
import 'package:{{project_name}}/lib_auth/models/auth_token_model.dart';
import 'package:{{project_name}}/lib_auth/services/auth_service.dart';
import 'package:{{project_name}}/lib_auth/services/user_account_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';

import '../mock/auth_service_mock.dart';
import '../mock/go_router_mock.dart';
import '../mock/user_account_service_mock.dart';
import '../stubs.dart';

void main() {
  late UserAccountService userAccountService;
  late CoordinatorBlocType coordinatorBloc;
  late AuthService authService;
  late CoordinatorStates coordinatorStates;
  late GoRouter router;

  void defineWhen(
      {String? username,
      String? password,
      AuthTokenModel? authToken,
      isAuthenticated}) {
    when(userAccountService.logout()).thenAnswer((_) => Future.value());

    when(userAccountService.loadPermissions())
        .thenAnswer((_) => Future.value());

    if (username != null && password != null) {
      when(userAccountService.login(username: username, password: password))
          .thenAnswer((_) => Future.value(Stubs.userModel));
    }

    if (authToken != null) {
      when(userAccountService.saveTokens(authToken))
          .thenAnswer((_) => Future.value());
    }

    when(userAccountService.subscribeForNotifications())
        .thenAnswer((_) => Future.value());

    when(authService.isAuthenticated())
        .thenAnswer((_) => Future.value(isAuthenticated));

    when(authService.logout()).thenAnswer((_) => Future.value());

    when(authService.clearAuthData()).thenAnswer((_) => Future.value());

    when(authService.fetchNewToken())
        .thenAnswer((_) => Future.value(Stubs.authTokenModel));

    when(authService.getRefreshToken())
        .thenAnswer((_) => Future.value(Stubs.refreshToken));

    when(authService.getToken())
        .thenAnswer((_) => Future.value(Stubs.authToken));

    when(authService.saveRefreshToken(Stubs.refreshToken))
        .thenAnswer((_) => Future.value());

    when(authService.saveToken(Stubs.authToken))
        .thenAnswer((_) => Future.value());

    when(authService.authenticate(email: username, password: password))
        .thenAnswer((_) => Future.value(Stubs.userWithAuthTokenModel));

    when(authService.getCurrentUser())
        .thenAnswer((_) => Future.value(Stubs.userModel));

    when(coordinatorStates.isAuthenticated)
        .thenAnswer((_) => Stream.value(isAuthenticated));
  }

  UserAccountBloc bloc() => UserAccountBloc(
        userAccountService,
        coordinatorBloc,
        authService,
        router,
      );

  setUp(() {
    coordinatorStates = coordinatorStatesMockFactory();

    userAccountService = userAccountServiceMockFactory();
    authService = authServiceMockFactory();
    coordinatorBloc = coordinatorBlocMockFactory(states: coordinatorStates);
    router = goRouterMockFactory();
  });

  rxBlocTest<UserAccountBlocType, bool>(
      'test user_account_test_dart state loggedIn',
      build: () async {
        defineWhen(isAuthenticated: false);
        return bloc();
      },
      act: (bloc) async {
        bloc.events.logout();
      },
      state: (bloc) => bloc.states.loggedIn,
      expect: [false]);

  rxBlocTest<UserAccountBlocType, bool>(
      'test user_account_test_dart state isLoading',
      build: () async {
        defineWhen(isAuthenticated: false);
        return bloc();
      },
      act: (bloc) async {
        bloc.events.logout();
      },
      state: (bloc) => bloc.states.isLoading,
      expect: [false]);
}
