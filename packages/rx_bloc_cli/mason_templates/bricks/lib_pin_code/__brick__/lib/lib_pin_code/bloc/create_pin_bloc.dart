{{> licence.dart }}

import 'dart:async';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../services/create_pin_code_service.dart';
import '../services/pin_biometrics_service.dart';

part 'create_pin_bloc.rxb.g.dart';

/// A contract class containing all events of the PinCodeBloC.
abstract class CreatePinBlocEvents {
  /// Event called, when a pin is created, after the verification is successful.
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void checkIsPinCreated();

  void deleteSavedData();

  /// Check if biometrics are enabled for the app.
  void checkAreBiometricsEnabled();

}

/// A contract class containing all states of the PinCodeBloC.
abstract class CreatePinBlocStates {
  Stream<bool> get isPinCreated;

  ConnectableStream<void> get deletedData;

  ConnectableStream<bool> get areBiometricsEnabled;

}

@RxBloc()
class CreatePinBloc extends $CreatePinBloc {
  CreatePinBloc({
    required this.service,
    required this.pinBiometricsService,
    required this.coordinatorBloc,
  }) {
    deletedData.connect().addTo(_compositeSubscription);
  }

  final CoordinatorBlocType coordinatorBloc;
  final CreatePinCodeService service;
  final PinBiometricsService pinBiometricsService;

  @override
  ConnectableStream<bool> _mapToAreBiometricsEnabledState() =>
      _$checkAreBiometricsEnabledEvent
          .switchMap((_) =>
              pinBiometricsService.areBiometricsEnabled().asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();

  @override
  Stream<bool> _mapToIsPinCreatedState() => Rx.merge([
        _$checkIsPinCreatedEvent,
        coordinatorBloc.states.checkIsPinCreatedOnLogout
      ])
          .startWith(null)
          .switchMap((_) => service.checkIsPinCreated().asResultStream())
          .setResultStateHandler(this)
          .whereSuccess();

  @override
  ConnectableStream<void> _mapToDeletedDataState() => _$deleteSavedDataEvent
      .switchMap((_) => service.deleteSavedData().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .publish();
}
