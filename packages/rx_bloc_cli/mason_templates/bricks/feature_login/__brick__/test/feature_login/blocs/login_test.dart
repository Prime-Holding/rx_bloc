import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_login/blocs/login_bloc.dart';
import 'package:{{project_name}}/feature_login/services/login_validator_service.dart';
import 'package:{{project_name}}/lib_auth/services/user_account_service.dart';

import 'login_test.mocks.dart';

@GenerateMocks([
  CoordinatorBlocType,
  UserAccountService,
  LoginValidatorService,
])
void main() {
  late CoordinatorBlocType coordinatorBloc;
  late UserAccountService userAccountService;
  late LoginValidatorService validatorService;

  void defineWhen() {}

  LoginBloc loginBloc() => LoginBloc(
        coordinatorBloc,
        userAccountService,
        validatorService,
      );
  setUp(() {
    coordinatorBloc = MockCoordinatorBlocType();
    userAccountService = MockUserAccountService();
    validatorService = MockLoginValidatorService();
  });

  group('test login_bloc_dart state email', () {
    rxBlocTest<LoginBlocType, String>('test login_bloc_dart state email',
        build: () async {
          defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.email,
        expect: []);
  });

  group('test login_bloc_dart state password', () {
    rxBlocTest<LoginBlocType, String>('test login_bloc_dart state password',
        build: () async {
          defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.password,
        expect: []);
  });

  group('test login_bloc_dart state loggedIn', () {
    rxBlocTest<LoginBlocType, bool>('test login_bloc_dart state loggedIn',
        build: () async {
          defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.loggedIn,
        expect: []);
  });

  group('test login_bloc_dart state showErrors', () {
    rxBlocTest<LoginBlocType, bool>('test login_bloc_dart state showErrors',
        build: () async {
          defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.showErrors,
        expect: []);
  });

  group('test login_bloc_dart state isLoading', () {
    rxBlocTest<LoginBlocType, bool>('test login_bloc_dart state isLoading',
        build: () async {
          defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.isLoading,
        expect: []);
  });

  group('test login_bloc_dart state errors', () {
    rxBlocTest<LoginBlocType, ErrorModel>('test login_bloc_dart state errors',
        build: () async {
          defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.errors,
        expect: []);
  });
}
