{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../base/common_blocs/coordinator_bloc.dart';
import '../services/create_pin_code_service.dart';

part 'create_pin_bloc.rxb.g.dart';

/// A contract class containing all events of the PinCodeBloC.
abstract class CreatePinBlocEvents {
  /// Event called, when a pin is created, after the verification is successful.
  void checkIsPinCreated();

  void deleteSavedData();
}

/// A contract class containing all states of the PinCodeBloC.
abstract class CreatePinBlocStates {
  ConnectableStream<bool> get isPinCreated;

  ConnectableStream<void> get deletedData;

  ConnectableStream<bool> get deleteStoredPinData;
}

@RxBloc()
class CreatePinBloc extends $CreatePinBloc {
  CreatePinBloc({
    required this.service,
    required this.coordinatorBloc,
  }) {
    deletedData.connect().addTo(_compositeSubscription);
    isPinCreated.connect().addTo(_compositeSubscription);
    deleteStoredPinData.connect().addTo(_compositeSubscription);
  }

  final CoordinatorBlocType coordinatorBloc;
  final CreatePinCodeService service;

  @override
  ConnectableStream<bool> _mapToIsPinCreatedState() => Rx.merge([
        _$checkIsPinCreatedEvent,
        coordinatorBloc.states.userLoggedIn,
      ])
          .startWith(null)
          .switchMap((_) => service.checkIsPinCreated().asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publishReplay(maxSize: 1);

  @override
  ConnectableStream<void> _mapToDeletedDataState() => _$deleteSavedDataEvent
      .switchMap((_) => service.deleteSavedData().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  ConnectableStream<bool> _mapToDeleteStoredPinDataState() =>
      coordinatorBloc.states.userLogOut
          .switchMap((_) => service.deleteStoredPin().asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();
}
