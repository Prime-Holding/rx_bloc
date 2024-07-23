import 'dart:developer';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_auth_matrix/models/auth_matrix_action.dart';
import '../../lib_auth_matrix/models/auth_matrix_method.dart';
import '../../lib_auth_matrix/models/auth_matrix_response.dart';
import '../../lib_auth_matrix/models/payload/actions/auth_matrix_address_payload.dart';
import '../../lib_auth_matrix/models/payload/actions/auth_matrix_unlock_payload.dart';
import '../../lib_auth_matrix/services/auth_matrix_service.dart';

part 'auth_matrix_edit_address_bloc.rxb.g.dart';

/// A contract class containing all events of the AuthMatrixEditAddressBloC.
abstract class AuthMatrixEditAddressBlocEvents {
  void saveAddress({
    required String city,
    required String streetAddress,
    required String countryCode,
  });

  void unlock();
}

/// A contract class containing all states of the AuthMatrixEditAddressBloC.
abstract class AuthMatrixEditAddressBlocStates {
  /// The state emits an event of each step of the change address auth matrix process.
  ConnectableStream<AuthMatrixResponse> get onAddressSaved;

  /// The state emits an event of each step of the auth unlock matrix process.
  ConnectableStream<AuthMatrixResponse> get onUnlocked;

  Stream<AuthMatrixAction> get onAuthMatrixCompleted;

  /// The state emits an error occurs during the auth matrix process.
  Stream<ErrorModel> get error;
}

@RxBloc()
class AuthMatrixEditAddressBloc extends $AuthMatrixEditAddressBloc {
  AuthMatrixEditAddressBloc(this._service) {
    onAddressSaved.connect().addTo(_compositeSubscription);
    onUnlocked.connect().addTo(_compositeSubscription);

    // Demonstrates that listeners can be added to the [AuthMatrixService]
    // for handling generic-purpose side-effects.
    _service.onResponse.listen((event) {
      log('AuthMatrixService.onResponse($event)');
    }).addTo(_compositeSubscription);
  }

  final AuthMatrixService _service;

  @override
  Stream<ErrorModel> _mapToErrorState() => errorState.mapToErrorModel();

  @override
  ConnectableStream<AuthMatrixResponse> _mapToOnAddressSavedState() =>
      _$saveAddressEvent
          // The exhaustMap operator ensures that the previous auth matrix process is completed
          .exhaustMap(
            (address) => _service
                .initiateAuthMatrix(
                  payload: AuthMatrixAddressPayload(
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
  ConnectableStream<AuthMatrixResponse> _mapToOnUnlockedState() => _$unlockEvent
      // The exhaustMap operator ensures that the previous auth matrix process is completed
      .exhaustMap(
        (address) => _service
            .initiateAuthMatrix(payload: AuthMatrixUnlockPayload())
            .asResultStream(),
      )
      .setErrorStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  Stream<AuthMatrixAction> _mapToOnAuthMatrixCompletedState() => Rx.merge([
        onAddressSaved
            .where((event) => event.authMethod.isComplete)
            .map((event) => AuthMatrixAction.changeAddress),
        onUnlocked
            .where((event) => event.authMethod.isComplete)
            .map((event) => AuthMatrixAction.unlock),
      ]);
}
