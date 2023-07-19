{{> licence.dart }}

import 'dart:async';

import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../services/app_pin_code_service.dart';
import '../services/pin_biometrics_service.dart';

part 'pin_bloc.rxb.g.dart';

/// A contract class containing all events of the PinCodeBloC.
abstract class PinBlocEvents {
  /// Event called with true when a pin is created, after the verification
  /// is successful. It is called with false when [isPinCreated] state is false
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void checkIsPinCreated();

  /// Event for the verification pin entered, before updating with a new pin
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void setIsVerificationPinCorrect({bool? isVerificationPinCorrect});

  void setPinCodeType(bool isFromSessionTimeout);

  void deleteSavedData();

  void deleteStoredPin();

  /// Check if biometrics are enabled for the app.
  void checkAreBiometricsEnabled();

  void temporaryDisableBiometrics(bool disable);

  void setSessionState(SessionState state);
}

/// A contract class containing all states of the PinCodeBloC.
abstract class PinBlocStates {
  ConnectableStream<SessionState> get sessionValue;

  /// This state to be passed to the SessionTimeoutManager
  ConnectableStream<SessionState> get sessionState;

  Stream<bool> get isPinCreated;

  ConnectableStream<bool> get pinCodeType;

  ConnectableStream<void> get deletedData;

  ConnectableStream<void> get deleteStoredPinData;

  ConnectableStream<bool> get areBiometricsEnabled;

  /// Temporary disable biometrics on pin verification process
  ConnectableStream<void> get biometricsDisabled;
}

@RxBloc()
class PinBloc extends $PinBloc {
  PinBloc({
    required this.service,
    required this.pinBiometricsService,
    required this.coordinatorBloc,
  }) {
    pinCodeType.connect().addTo(_compositeSubscription);
    deletedData.connect().addTo(_compositeSubscription);
    deleteStoredPinData.connect().addTo(_compositeSubscription);
    sessionValue.connect().addTo(_compositeSubscription);
    sessionState.connect().addTo(_compositeSubscription);
    biometricsDisabled.connect().addTo(_compositeSubscription);
  }

  final CoordinatorBlocType coordinatorBloc;
  final PinCodeService service;
  final PinBiometricsService pinBiometricsService;
  final StreamController<SessionState> _sessionStateController =
      StreamController<SessionState>();

  @override
  ConnectableStream<void> _mapToBiometricsDisabledState() =>
      _$temporaryDisableBiometricsEvent
          .switchMap((disable) => pinBiometricsService
              .temporaryDisableBiometrics(disable)
              .asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();

  @override
  ConnectableStream<void> _mapToDeleteStoredPinDataState() => Rx.merge([
        coordinatorBloc.states.deleteStoredPinOnLogout,
        _$deleteStoredPinEvent
      ])
          .switchMap((_) =>
              (service as AppPinCodeService).deleteStoredPin().asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();

  @override
  ConnectableStream<SessionState> _mapToSessionStateState() =>
      _sessionStateController.stream.publish();

  @override
  ConnectableStream<SessionState> _mapToSessionValueState() =>
      _$setSessionStateEvent.doOnData((event) {
        _sessionStateController.add(event);
      }).publish();

  @override
  ConnectableStream<bool> _mapToAreBiometricsEnabledState() =>
      _$checkAreBiometricsEnabledEvent
          .switchMap((_) =>
              pinBiometricsService.areBiometricsEnabled().asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();

  @override
  ConnectableStream<bool> _mapToPinCodeTypeState() => _$setPinCodeTypeEvent
      .switchMap((value) =>
          (service as AppPinCodeService).setPinCodeType(value).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .shareReplay(maxSize: 1)
      .publish();

  @override
  Stream<bool> _mapToIsPinCreatedState() => Rx.merge([
        _$checkIsPinCreatedEvent,
        coordinatorBloc.states.checkIsPinCreatedOnLogout
      ])
          .startWith(null)
          .switchMap((_) => (service as AppPinCodeService)
              .checkIsPinCreated()
              .asResultStream())
          .setResultStateHandler(this)
          .whereSuccess();

  @override
  ConnectableStream<void> _mapToDeletedDataState() => _$deleteSavedDataEvent
      .switchMap((_) =>
          (service as AppPinCodeService).deleteSavedData().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  void dispose() {
    _sessionStateController.close();
    super.dispose();
  }
}
