{{> licence.dart }}

import 'dart:async';

import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../services/pin_biometrics_service.dart';
import '../services/verify_pin_code_service.dart';

part 'update_and_verify_pin_bloc.rxb.g.dart';

/// A contract class containing all events of the PinCodeBloC.
abstract class UpdateAndVerifyPinBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void checkIsPinUpdated();

  void deleteSavedData();

  /// Changes the state to start or stop listening of user inactivity
  void setSessionState(SessionState state);
}

/// A contract class containing all states of the PinCodeBloC.
abstract class UpdateAndVerifyPinBlocStates {
  ConnectableStream<void> get isPinUpdated;

  /// This state is passed to the SessionTimeoutManager
  ConnectableStream<SessionState> get sessionValue;

  ConnectableStream<void> get deletedData;

  ConnectableStream<void> get deleteStoredPinData;
}

@RxBloc()
class UpdateAndVerifyPinBloc extends $UpdateAndVerifyPinBloc {
  UpdateAndVerifyPinBloc({
    required this.service,
    required this.pinBiometricsService,
    required this.coordinatorBloc,
  }) {
    deletedData.connect().addTo(_compositeSubscription);
    deleteStoredPinData.connect().addTo(_compositeSubscription);
    sessionValue.connect().addTo(_compositeSubscription);
    isPinUpdated.connect().addTo(_compositeSubscription);
  }

  final CoordinatorBlocType coordinatorBloc;
  final VerifyPinCodeService service;
  final PinBiometricsService pinBiometricsService;
  final StreamController<SessionState> _sessionStateController =
      StreamController<SessionState>();

  @override
  ConnectableStream<void> _mapToDeleteStoredPinDataState() =>
      coordinatorBloc.states.userLogOut
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
  ConnectableStream<void> _mapToDeletedDataState() => _$deleteSavedDataEvent
      .switchMap((_) => service.deleteSavedData().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  ConnectableStream<void> _mapToIsPinUpdatedState() =>
      _$checkIsPinUpdatedEvent.publish();

  @override
  void dispose() {
    _sessionStateController.close();
    super.dispose();
  }
}
