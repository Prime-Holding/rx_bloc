import 'package:flutter_test/flutter_test.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/bloc/update_and_verify_pin_bloc.dart';
import 'package:{{project_name}}/lib_pin_code/services/pin_biometrics_service.dart';
import 'package:{{project_name}}/lib_pin_code/services/verify_pin_code_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../mock/pin_biometrics_service_mock.dart';
import '../mock/verify_pin_code_service_mock.dart';
import '../stubs.dart';

void main() {
  late CoordinatorBlocType coordinatorBloc;
  late VerifyPinCodeService verifyPinCodeService;
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

    when(coordinatorStates.userLogOut).thenAnswer((_) => Stream.value(null));

    when(verifyPinCodeService.deleteStoredPin())
        .thenAnswer((_) => Future.value());

    when(pinBiometricsService.areBiometricsEnabled())
        .thenAnswer((_) => Future.value(true));

    when(pinBiometricsService.setBiometricsEnabled(true))
        .thenAnswer((_) => Future.value());

    when(pinBiometricsService.setBiometricsEnabled(false))
        .thenAnswer((_) => Future.value());

    when(verifyPinCodeService.checkIsPinCreated())
        .thenAnswer((_) => Future.value(isPinCreated));

    when(verifyPinCodeService.isPinCodeInSecureStorage())
        .thenAnswer((_) => Future.value(isPinCodeInSecureStorage));

    if (pinCode != null) {
      if (encryptedPinCode != null) {
        when(verifyPinCodeService.encryptPinCode(pinCode))
            .thenAnswer((_) => Future.value(encryptedPinCode));
      }

      when(verifyPinCodeService.getPinLength())
          .thenAnswer((_) => Future.value(pinCode.length));

      when(verifyPinCodeService.getPinCode())
          .thenAnswer((_) => Future.value(pinCode));
    }
  }

  UpdateAndVerifyPinBloc bloc() => UpdateAndVerifyPinBloc(
      service: verifyPinCodeService,
      pinBiometricsService: pinBiometricsService,
      coordinatorBloc: coordinatorBloc);

  setUp(() {
    coordinatorStates = coordinatorStatesMockFactory();
    coordinatorEvents = coordinatorEventsMockFactory();
    verifyPinCodeService = verifyPinCodeServiceMockFactory();
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
}
