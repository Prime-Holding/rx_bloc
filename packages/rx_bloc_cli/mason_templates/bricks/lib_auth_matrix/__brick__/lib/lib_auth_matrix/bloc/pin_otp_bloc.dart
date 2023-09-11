{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../models/auth_matrix_response.dart';
import '../services/auth_matrix_service.dart';

part 'pin_otp_bloc.rxb.g.dart';

/// A contract class containing all events of the PinOtpBloC.
abstract class PinOtpBlocEvents {
  void cancelAuthMatrix(
      AuthMatrixResponse authMatrixResponse, String endToEndId);
}

/// A contract class containing all states of the PinOtpBloC.
abstract class PinOtpBlocStates {}

@RxBloc()
class PinOtpBloc extends $PinOtpBloc {
  PinOtpBloc(
    this._authMatrixService,
  ) {
    _$cancelAuthMatrixEvent
        .switchMap((value) => _authMatrixService
            .cancelAuthMatrix(
              value.endToEndId,
              value.authMatrixResponse.transactionId,
            )
            .asStream())
        .listen(null)
        .addTo(_compositeSubscription);
  }

  final AuthMatrixService _authMatrixService;
}
