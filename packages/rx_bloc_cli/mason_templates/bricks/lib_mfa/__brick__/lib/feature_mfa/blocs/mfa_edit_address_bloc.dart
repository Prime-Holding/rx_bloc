import 'dart:developer';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_mfa/models/payload/actions/mfa_address_payload.dart';
import '../../lib_mfa/models/payload/actions/mfa_unlock_payload.dart';
import '../../lib_mfa/models/mfa_action.dart';
import '../../lib_mfa/models/mfa_method.dart';
import '../../lib_mfa/models/mfa_response.dart';
import '../../lib_mfa/services/mfa_service.dart';

part 'mfa_edit_address_bloc.rxb.g.dart';

/// A contract class containing all events of the mfaEditAddressBloC.
abstract class MfaEditAddressBlocEvents {
  void saveAddress({
    required String city,
    required String streetAddress,
    required String countryCode,
  });

  void unlock();
}

/// A contract class containing all states of the mfaEditAddressBloC.
abstract class MfaEditAddressBlocStates {
  /// The state emits an event of each step of the change address mfa process.
  ConnectableStream<MfaResponse> get onAddressSaved;

  /// The state emits an event of each step of the auth unlock MFA process.
  ConnectableStream<MfaResponse> get onUnlocked;

  Stream<MfaAction> get onMfaCompleted;

  /// The state emits an error occurs during the mfa process.
  Stream<ErrorModel> get error;
}

@RxBloc()
class MfaEditAddressBloc extends $MfaEditAddressBloc {
  MfaEditAddressBloc(this._service) {
    onAddressSaved.connect().addTo(_compositeSubscription);
    onUnlocked.connect().addTo(_compositeSubscription);

    // Demonstrates that listeners can be added to the [mfaService]
    // for handling generic-purpose side-effects.
    _service.onResponse.listen((event) {
      log('MfaService.onResponse($event)');
    }).addTo(_compositeSubscription);
  }

  final MfaService _service;

  @override
  Stream<ErrorModel> _mapToErrorState() => errorState.mapToErrorModel();

  @override
  ConnectableStream<MfaResponse> _mapToOnAddressSavedState() => _$saveAddressEvent
      // The exhaustMap operator ensures that the previous mfa process is completed
      .exhaustMap(
        (address) => _service
            .authenticate(
              payload: MfaAddressPayload(
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
  ConnectableStream<MfaResponse> _mapToOnUnlockedState() => _$unlockEvent
      // The exhaustMap operator ensures that the previous mfa process is completed
      .exhaustMap(
        (address) =>
            _service.authenticate(payload: MfaUnlockPayload()).asResultStream(),
      )
      .setErrorStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  Stream<MfaAction> _mapToOnMfaCompletedState() => Rx.merge([
        onAddressSaved
            .where((event) => event.authMethod.isComplete)
            .map((event) => MfaAction.changeAddress),
        onUnlocked
            .where((event) => event.authMethod.isComplete)
            .map((event) => MfaAction.unlock),
      ]);
}
