import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';
import 'package:{{project_name}}/base/common_services/validators/credentials_validator_service.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_login/blocs/login_bloc.dart';
import 'package:{{project_name}}/lib_auth/services/user_account_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../base/common_blocs/router_bloc_mock.dart';
import '../stubs.dart';
import 'login_test.mocks.dart';

@GenerateMocks([
  CoordinatorBlocType,
  UserAccountService,
  CredentialsValidatorService,
])
void main() {
  late CoordinatorBlocType coordinatorBloc;
  late UserAccountService userAccountService;
  late CredentialsValidatorService validatorService;

  void defineWhen({String? username, String? password, ErrorModel? error}) {
    when(userAccountService.loadPermissions())
        .thenAnswer((_) => Future.value());

    when(validatorService.validateEmail('')).thenAnswer((_) => '');

    when(validatorService.validatePassword('')).thenAnswer((_) => '');

    if (username != null) {
      if (error != null) {
        when(validatorService.validateEmail(username)).thenThrow((_) => error);
      } else {
        when(validatorService.validateEmail(username))
            .thenAnswer((_) => username);
      }
    }

    if (password != null) {
      if (error != null) {
        when(validatorService.validatePassword(password))
            .thenThrow((_) => error);
      } else {
        when(validatorService.validatePassword(password))
            .thenAnswer((_) => password);
      }
    }

    if (username != null && password != null) {
      when(userAccountService.login(username: username, password: password))
          .thenAnswer((_) => Future.value());
    }

    when(userAccountService.subscribeForNotifications())
        .thenAnswer((_) => Future.value());
  }

  LoginBloc loginBloc() => LoginBloc(
        coordinatorBloc,
        userAccountService,
        validatorService,
        routerBlocMockFactory(),
      );
  setUp(() {
    coordinatorBloc = coordinatorBlocMockFactory();
    userAccountService = MockUserAccountService();
    validatorService = MockCredentialsValidatorService();
  });

  group('test login_bloc_dart', () {
    rxBlocTest<LoginBlocType, String>('test login_bloc_dart state email',
        build: () async {
          defineWhen(username: Stubs.email, password: Stubs.password);
          return loginBloc();
        },
        act: (bloc) async {
          bloc.events.setEmail(Stubs.email);
        },
        state: (bloc) => bloc.states.email,
        expect: ['', Stubs.email]);

    rxBlocTest<LoginBlocType, String>('test login_bloc_dart state password',
        build: () async {
          defineWhen(username: Stubs.email, password: Stubs.password);
          return loginBloc();
        },
        act: (bloc) async {
          bloc.events.setPassword(Stubs.password);
        },
        state: (bloc) => bloc.states.password,
        expect: ['', Stubs.password]);

    rxBlocFakeAsyncTest<LoginBlocType, bool>(
        'test login_bloc_dart state loggedIn',
        build: () {
          defineWhen(username: Stubs.email, password: Stubs.password);
          return loginBloc();
        },
        act: (bloc, fakeAsync) async {
          fakeAsync.elapse(const Duration(seconds: 1));
          bloc.events.login();
          fakeAsync.elapse(const Duration(seconds: 1));
          bloc.events.setPassword(Stubs.password);
          bloc.events.setEmail(Stubs.email);
          bloc.events.login();
        },
        state: (bloc) => bloc.states.loggedIn,
        expect: [false, true]);

    rxBlocTest<LoginBlocType, bool>('test login_bloc_dart state errors',
        build: () async {
          defineWhen(
              username: Stubs.email,
              password: Stubs.password,
              error: Stubs.error);
          return loginBloc();
        },
        act: (bloc) async {
          bloc.events.setEmail(Stubs.email);
          bloc.events.setPassword(Stubs.password);
          bloc.events.login();
        },
        state: (bloc) => bloc.states.showErrors,
        expect: [false, true]);
  });
}
