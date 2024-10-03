import 'package:flutter_test/flutter_test.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/bloc/update_and_verify_pin_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/services/pin_biometrics_service.dart';
import 'package:{{project_name}}/lib_pin_code/services/update_and_verify_pin_code_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../mock/pin_biometrics_service_mock.dart';
import '../mock/update_and_verify_pin_code_service_mock.dart';
import '../stubs.dart';

void main() {
  late CoordinatorBlocType coordinatorBloc;
  late UpdateAndVerifyPinCodeService updateAndVerifyPinCodeService;
  late PinBiometricsService pinBiometricsService;
  late CoordinatorStates coordinatorStates;
  late CoordinatorEvents coordinatorEvents;

  void defineWhen({
    String? pinCode,
    String? encryptedPinCode,
    bool isPinCorrect = false,
    bool isPinCreated = false,
    bool isPinCodeInSecureStorage = false,
    bool isPinDeleted = false,
  }) {
    when(coordinatorStates.userLoggedIn)
        .thenAnswer((_) => const Stream.empty());

    when(coordinatorStates.userLogOut)
        .thenAnswer((_) => Stream.value(Result.success(true)));

    when(updateAndVerifyPinCodeService.deleteStoredPin())
        .thenAnswer((_) => Future.value());

    when(pinBiometricsService.areBiometricsEnabled())
        .thenAnswer((_) => Future.value(true));

    when(pinBiometricsService.setBiometricsEnabled(true))
        .thenAnswer((_) => Future.value());

    when(pinBiometricsService.setBiometricsEnabled(false))
        .thenAnswer((_) => Future.value());

    when(updateAndVerifyPinCodeService.setPinCodeType(false))
        .thenAnswer((_) => Future.value(false));

    when(updateAndVerifyPinCodeService.setPinCodeType(true))
        .thenAnswer((_) => Future.value(true));

    when(updateAndVerifyPinCodeService.checkIsPinCreated())
        .thenAnswer((_) => Future.value(isPinCreated));

    when(updateAndVerifyPinCodeService.isPinCodeInSecureStorage())
        .thenAnswer((_) => Future.value(isPinCodeInSecureStorage));

    if (pinCode != null) {
      if (encryptedPinCode != null) {
        when(updateAndVerifyPinCodeService.encryptPinCode(pinCode))
            .thenAnswer((_) => Future.value(encryptedPinCode));
      }

      when(updateAndVerifyPinCodeService.getPinLength())
          .thenAnswer((_) => Future.value(pinCode.length));

      when(updateAndVerifyPinCodeService.verifyPinCode(pinCode))
          .thenAnswer((_) => Future.value(isPinCorrect));

      when(updateAndVerifyPinCodeService.getPinCode())
          .thenAnswer((_) => Future.value(pinCode));
    }
  }

  UpdateAndVerifyPinBloc bloc() => UpdateAndVerifyPinBloc(
      service: updateAndVerifyPinCodeService,
      pinBiometricsService: pinBiometricsService,
      coordinatorBloc: coordinatorBloc);

  setUp(() {
    coordinatorStates = coordinatorStatesMockFactory();
    coordinatorEvents = coordinatorEventsMockFactory();
    updateAndVerifyPinCodeService = updateAndVerifyPinCodeServiceMockFactory();
    pinBiometricsService = pinBiometricsServiceMockFactory();
    coordinatorBloc = coordinatorBlocMockFactory(
        states: coordinatorStates, events: coordinatorEvents);
  });

  rxBlocTest<UpdateAndVerifyPinBlocType, SessionState>(
      'test update_and_verify_pin_bloc_test state sessionValue',
      build: () async {
        defineWhen();
        return bloc();
      },
      act: (bloc) async {
        bloc.events.setSessionState(Stubs.sessionStartListening);
        bloc.events.setSessionState(Stubs.sessionStopListening);
        bloc.events.setSessionState(Stubs.sessionStartListening);
        bloc.events.setSessionState(Stubs.sessionStartListening);
      },
      state: (bloc) => bloc.states.sessionValue,
      expect: [
        Stubs.sessionStartListening,
        Stubs.sessionStopListening,
        Stubs.sessionStartListening,
        Stubs.sessionStartListening,
      ]);

  rxBlocFakeAsyncTest<UpdateAndVerifyPinBlocType, bool>(
      'test update_and_verify_pin_bloc_test state pinCodeType',
      build: () {
        defineWhen();
        return bloc();
      },
      act: (bloc, fakeAsync) async {
        bloc.events.setPinCodeType(true);
        fakeAsync.elapse(const Duration(milliseconds: 1));
        bloc.events.setPinCodeType(false);
        fakeAsync.elapse(const Duration(milliseconds: 1));
        bloc.events.setPinCodeType(true);
        fakeAsync.elapse(const Duration(milliseconds: 1));
        bloc.events.setPinCodeType(true);
      },
      state: (bloc) => bloc.states.pinCodeType,
      expect: [true, false, true, true]);
}
