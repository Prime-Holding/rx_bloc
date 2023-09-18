{{> licence.dart }}

import 'dart:async';

import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../services/pin_biometrics_service.dart';
import '../services/update_and_verify_pin_code_service.dart';

part 'update_and_verify_pin_bloc.rxb.g.dart';

/// A contract class containing all events of the PinCodeBloC.
abstract class UpdateAndVerifyPinBlocEvents {
  /// Sets whether the pin code is from user inactivity
  void setPinCodeType(bool isFromSessionTimeout);

  void deleteSavedData();

  /// Check if biometrics are enabled for the app.
  void checkAreBiometricsEnabled();

  /// Disables biometrics while using a page
  void setBiometricsEnabled(bool enabled);

  /// Changes the state to start or stop listening of user inactivity
  void setSessionState(SessionState state);
}

/// A contract class containing all states of the PinCodeBloC.
abstract class UpdateAndVerifyPinBlocStates {
  /// This state is passed to the SessionTimeoutManager
  ConnectableStream<SessionState> get sessionValue;

  ConnectableStream<bool> get pinCodeType;

  ConnectableStream<void> get deletedData;

  ConnectableStream<void> get deleteStoredPinData;

  ConnectableStream<bool> get areBiometricsEnabled;

  /// Temporary disable biometrics on pin verification process
  ConnectableStream<void> get biometricsEnabled;
}

@RxBloc()
class UpdateAndVerifyPinBloc extends $UpdateAndVerifyPinBloc {
  UpdateAndVerifyPinBloc({
    required this.service,
    required this.pinBiometricsService,
    required this.coordinatorBloc,
  }) {
    pinCodeType.connect().addTo(_compositeSubscription);
    deletedData.connect().addTo(_compositeSubscription);
    deleteStoredPinData.connect().addTo(_compositeSubscription);
    sessionValue.connect().addTo(_compositeSubscription);
    biometricsEnabled.connect().addTo(_compositeSubscription);
  }

  final CoordinatorBlocType coordinatorBloc;
  final UpdateAndVerifyPinCodeService service;
  final PinBiometricsService pinBiometricsService;
  final StreamController<SessionState> _sessionStateController =
      StreamController<SessionState>();

  @override
  ConnectableStream<void> _mapToBiometricsEnabledState() =>
      _$setBiometricsEnabledEvent
          .switchMap((enable) => pinBiometricsService
              .setBiometricsEnabled(enable)
              .asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();

  @override
  ConnectableStream<void> _mapToDeleteStoredPinDataState() => Rx.merge([
        coordinatorBloc.states.deleteStoredPinOnLogout,
      ])
          .switchMap((_) => service.deleteStoredPin().asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();

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
      .switchMap((value) => service.setPinCodeType(value).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .shareReplay(maxSize: 1)
      .publish();

  @override
  ConnectableStream<void> _mapToDeletedDataState() => _$deleteSavedDataEvent
      .switchMap((_) => service.deleteSavedData().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  void dispose() {
    _sessionStateController.close();
    super.dispose();
  }
}
