// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test_app/base/common_blocs/coordinator_bloc.dart';
import 'package:test_app/base/common_use_cases/login_use_case.dart';
import 'package:test_app/base/utils/validators/validators.dart';
import 'package:test_app/feature_login/blocs/login_bloc.dart';

import '../../helpers/stubs.dart';
import 'login_bloc_test.mocks.dart';

@GenerateMocks([
  LoginFieldValidators,
  LoginUseCase,
  CoordinatorBlocType,
  CoordinatorEvents,
])
void main() {
  late MockLoginUseCase loginUseCase;
  late MockCoordinatorBlocType coordinatorBloc;
  late MockLoginFieldValidators fieldValidators;
  late MockCoordinatorEvents coordinatorEvents;

  setUp(() {
    loginUseCase = MockLoginUseCase();
    coordinatorBloc = MockCoordinatorBlocType();
    coordinatorEvents = MockCoordinatorEvents();
    when(coordinatorBloc.events).thenReturn(coordinatorEvents);
    fieldValidators = MockLoginFieldValidators();
  });

  group('LoginBloc tests', () {
    rxBlocTest<LoginBlocType, String>(
      'Set username - success',
      build: () async {
        when(fieldValidators.validateEmail(any))
            .thenAnswer((_) => Stubs.validEmail);
        return LoginBloc(
          loginUseCase: loginUseCase,
          coordinatorBloc: coordinatorBloc,
          fieldValidators: fieldValidators,
        );
      },
      act: (bloc) async => bloc.events.setUsername(Stubs.validEmail),
      state: (bloc) => bloc.states.username,
      expect: ['', Stubs.validEmail, Stubs.validEmail],
    );

    rxBlocTest<LoginBlocType, String>(
      'Set password - success',
      build: () async {
        when(fieldValidators.validatePassword(any))
            .thenAnswer((_) => Stubs.validPassword);
        return LoginBloc(
          loginUseCase: loginUseCase,
          coordinatorBloc: coordinatorBloc,
          fieldValidators: fieldValidators,
        );
      },
      act: (bloc) async => bloc.events.setPassword(Stubs.validPassword),
      state: (bloc) => bloc.states.password,
      expect: ['', Stubs.validPassword, Stubs.validPassword],
    );

    rxBlocTest<LoginBlocType, bool>(
      'Success login',
      build: () async {
        when(fieldValidators.validateEmail(any))
            .thenAnswer((_) => Stubs.validEmail);
        when(fieldValidators.validatePassword(any))
            .thenAnswer((_) => Stubs.validPassword);

        when(coordinatorEvents.authenticated(isAuthenticated: false))
            .thenReturn(null);
        when(coordinatorEvents.authenticated(isAuthenticated: true))
            .thenReturn(null);

        when(
          loginUseCase.execute(
              username: Stubs.validEmail, password: Stubs.validPassword),
        ).thenAnswer((_) async => Future.value(true));
        return LoginBloc(
          loginUseCase: loginUseCase,
          coordinatorBloc: coordinatorBloc,
          fieldValidators: fieldValidators,
        );
      },
      act: (bloc) async {
        bloc.events.setUsername(Stubs.validEmail);
        bloc.events.setPassword(Stubs.validPassword);
        bloc.events.login();
      },
      skip: 1,
      //skip the initial value
      state: (bloc) => bloc.states.loggedIn,
      expect: [true],
    );

    rxBlocTest<LoginBlocType, bool>(
      'Failed login',
      build: () async {
        when(fieldValidators.validateEmail(any))
            .thenAnswer((_) => Stubs.validEmail);
        when(fieldValidators.validatePassword(any))
            .thenAnswer((_) => Stubs.validPassword);

        when(coordinatorEvents.authenticated(isAuthenticated: false))
            .thenReturn(null);
        when(coordinatorEvents.authenticated(isAuthenticated: true))
            .thenReturn(null);

        when(
          loginUseCase.execute(
              username: Stubs.validEmail, password: Stubs.validPassword),
        ).thenAnswer((_) async => Future.value(false));
        return LoginBloc(
          loginUseCase: loginUseCase,
          coordinatorBloc: coordinatorBloc,
          fieldValidators: fieldValidators,
        );
      },
      act: (bloc) async {
        bloc.events.setUsername(Stubs.validEmail);
        bloc.events.setPassword(Stubs.validPassword);
        bloc.events.login();
      },
      state: (bloc) => bloc.states.loggedIn,
      expect: [false],
    );

    rxBlocTest<LoginBlocType, bool>(
      'Show errors',
      build: () async {
        when(fieldValidators.validateEmail(any))
            .thenAnswer((_) => Stubs.invalidEmail);
        when(fieldValidators.validatePassword(any))
            .thenAnswer((_) => Stubs.invalidPassword);
        return LoginBloc(
          loginUseCase: loginUseCase,
          coordinatorBloc: coordinatorBloc,
          fieldValidators: fieldValidators,
        );
      },
      act: (bloc) async {
        bloc.events.setUsername(Stubs.invalidEmail);
        bloc.events.setPassword(Stubs.invalidPassword);
        bloc.events.login();
      },
      state: (bloc) => bloc.states.showErrors,
      expect: [false, true],
    );

    //TODO: fix those failing tests
    // rxBlocTest<LoginBlocType, String>(
    //   'Error handling',
    //   build: () async {
    //     when(fieldValidators.validateEmail(any))
    //         .thenAnswer((_) => Stubs.validEmail);
    //     when(fieldValidators.validatePassword(any))
    //         .thenAnswer((_) => Stubs.validPassword);
    //     when(loginUseCase.execute(
    //       username: Stubs.validEmail,
    //       password: Stubs.validPassword,
    //     )).thenAnswer(
    //       (_) async => Future.error('test error msg'),
    //     );
    //     return LoginBloc(
    //       loginUseCase: loginUseCase,
    //       coordinatorBloc: coordinatorBloc,
    //       fieldValidators: fieldValidators,
    //     );
    //   },
    //   act: (bloc) async {
    //     bloc.events.setUsername(Stubs.validEmail);
    //     bloc.events.setPassword(Stubs.validPassword);
    //     bloc.events.login();
    //   },
    //   state: (bloc) => bloc.states.errors,
    //   expect: [contains('test error msg')],
    // );
    //
    // rxBlocTest<LoginBlocType, bool>(
    //   'Loading state',
    //   build: () async {
    //     when(fieldValidators.validateEmail(any))
    //         .thenAnswer((_) => Stubs.validEmail);
    //     when(fieldValidators.validatePassword(any))
    //         .thenAnswer((_) => Stubs.validPassword);
    //     when(loginUseCase.execute(
    //       username: Stubs.validEmail,
    //       password: Stubs.validPassword,
    //     )).thenAnswer(
    //           (_) async => Future.value(true),
    //     );
    //     return LoginBloc(
    //       loginUseCase: loginUseCase,
    //       coordinatorBloc: coordinatorBloc,
    //       fieldValidators: fieldValidators,
    //     );
    //   },
    //   act: (bloc) async {
    //     bloc.events.setUsername(Stubs.validEmail);
    //     bloc.events.setPassword(Stubs.validPassword);
    //     bloc.events.login();
    //   },
    //   state: (bloc) => bloc.states.isLoading,
    //   expect: [false, true, false],
    // );
  });
}
