import 'dart:developer';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_tfa/models/payload/actions/tfa_address_payload.dart';
import '../../lib_tfa/models/payload/actions/tfa_unlock_payload.dart';
import '../../lib_tfa/models/tfa_action.dart';
import '../../lib_tfa/models/tfa_method.dart';
import '../../lib_tfa/models/tfa_response.dart';
import '../../lib_tfa/services/tfa_service.dart';

part 'tfa_edit_address_bloc.rxb.g.dart';

/// A contract class containing all events of the tfaEditAddressBloC.
abstract class TFAEditAddressBlocEvents {
  void saveAddress({
    required String city,
    required String streetAddress,
    required String countryCode,
  });

  void unlock();
}

/// A contract class containing all states of the tfaEditAddressBloC.
abstract class TFAEditAddressBlocStates {
  /// The state emits an event of each step of the change address tfa process.
  ConnectableStream<TFAResponse> get onAddressSaved;

  /// The state emits an event of each step of the auth unlock 2FA process.
  ConnectableStream<TFAResponse> get onUnlocked;

  Stream<TFAAction> get onTFACompleted;

  /// The state emits an error occurs during the tfa process.
  Stream<ErrorModel> get error;
}

@RxBloc()
class TFAEditAddressBloc extends $TFAEditAddressBloc {
  TFAEditAddressBloc(this._service) {
    onAddressSaved.connect().addTo(_compositeSubscription);
    onUnlocked.connect().addTo(_compositeSubscription);

    // Demonstrates that listeners can be added to the [tfaService]
    // for handling generic-purpose side-effects.
    _service.onResponse.listen((event) {
      log('TFAService.onResponse($event)');
    }).addTo(_compositeSubscription);
  }

  final TFAService _service;

  @override
  Stream<ErrorModel> _mapToErrorState() => errorState.mapToErrorModel();

  @override
  ConnectableStream<TFAResponse> _mapToOnAddressSavedState() => _$saveAddressEvent
      // The exhaustMap operator ensures that the previous tfa process is completed
      .exhaustMap(
        (address) => _service
            .authenticate(
              payload: TFAAddressPayload(
                city: address.city,
                streetAddress: address.streetAddress,
                countryCode: address.countryCode,
              ),
            )
            .asResultStream(),
      )
      .setErrorStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  ConnectableStream<TFAResponse> _mapToOnUnlockedState() => _$unlockEvent
      // The exhaustMap operator ensures that the previous tfa process is completed
      .exhaustMap(
        (address) =>
            _service.authenticate(payload: TFAUnlockPayload()).asResultStream(),
      )
      .setErrorStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  Stream<TFAAction> _mapToOnTFACompletedState() => Rx.merge([
        onAddressSaved
            .where((event) => event.authMethod.isComplete)
            .map((event) => TFAAction.changeAddress),
        onUnlocked
            .where((event) => event.authMethod.isComplete)
            .map((event) => TFAAction.unlock),
      ]);
}
