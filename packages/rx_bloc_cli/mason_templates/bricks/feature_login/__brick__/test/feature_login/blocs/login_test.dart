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
  late CoordinatorBlocType _coordinatorBloc;
  late UserAccountService _userAccountService;
  late LoginValidatorService _validatorService;

  void _defineWhen() {}

  LoginBloc loginBloc() => LoginBloc(
        _coordinatorBloc,
        _userAccountService,
        _validatorService,
      );
  setUp(() {
    _coordinatorBloc = MockCoordinatorBlocType();
    _userAccountService = MockUserAccountService();
    _validatorService = MockLoginValidatorService();
  });

  group('test login_bloc_dart state email', () {
    rxBlocTest<LoginBlocType, String>('test login_bloc_dart state email',
        build: () async {
          _defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.email,
        expect: []);
  });

  group('test login_bloc_dart state password', () {
    rxBlocTest<LoginBlocType, String>('test login_bloc_dart state password',
        build: () async {
          _defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.password,
        expect: []);
  });

  group('test login_bloc_dart state loggedIn', () {
    rxBlocTest<LoginBlocType, bool>('test login_bloc_dart state loggedIn',
        build: () async {
          _defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.loggedIn,
        expect: []);
  });

  group('test login_bloc_dart state showErrors', () {
    rxBlocTest<LoginBlocType, bool>('test login_bloc_dart state showErrors',
        build: () async {
          _defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.showErrors,
        expect: []);
  });

  group('test login_bloc_dart state isLoading', () {
    rxBlocTest<LoginBlocType, bool>('test login_bloc_dart state isLoading',
        build: () async {
          _defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.isLoading,
        expect: []);
  });

  group('test login_bloc_dart state errors', () {
    rxBlocTest<LoginBlocType, ErrorModel>('test login_bloc_dart state errors',
        build: () async {
          _defineWhen();
          return loginBloc();
        },
        act: (bloc) async {},
        state: (bloc) => bloc.states.errors,
        expect: []);
  });
}
