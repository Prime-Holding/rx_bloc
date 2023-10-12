{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../models/auth_matrix_action_type.dart';
import '../models/otp_model.dart';
import '../models/pin_only_model.dart';
import '../services/auth_matrix_service.dart';

part 'auth_matrix_bloc.rxb.g.dart';

/// A contract class containing all events of the AuthMatrixBloC.
abstract class AuthMatrixBlocEvents {
  /// Event triggered when the user taps on the submit pin/biometrics button
  void submitPinBiometrics();

  /// Event triggered when the user taps on the submit otp button
  void submitOtp();

  /// Event triggered when the user types in the text field
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void userData(String value);
}

/// A contract class containing all states of the AuthMatrixBloC.
abstract class AuthMatrixBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  ///State that emits when the user successfully completes the auth matrix flow
  Stream<void> get response;

  ///State of the text field
  Stream<String?> get textFieldValue;
}

@RxBloc()
class AuthMatrixBloc extends $AuthMatrixBloc {
  AuthMatrixBloc(
    this._authMatrixService,
  );

  final AuthMatrixService _authMatrixService;

  late final String _authMatrixEndToEndId =
      _authMatrixService.generateEndToEndId();

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<void> _mapToResponseState() => Rx.merge(
        [
          _$submitPinBiometricsEvent.switchMap(
            (_) => _authMatrixService
                .initialiseAuthMatrixFlow(
                    payload: PinOnlyModel(
                      AuthMatrixActionType.pinOnly,
                      _authMatrixEndToEndId,
                      _$userDataEvent.value,
                    ),
                    userData: _$userDataEvent.value)
                .asStream(),
          ),
          _$submitOtpEvent.switchMap(
            (_) => _authMatrixService
                .initialiseAuthMatrixFlow(
                    payload: OtpModel(
                      AuthMatrixActionType.pinAndOtp,
                      _authMatrixEndToEndId,
                      _$userDataEvent.value,
                    ),
                    userData: _$userDataEvent.value)
                .asStream(),
          ),
        ],
      ).asResultStream().setResultStateHandler(this).whereSuccess();

  @override
  Stream<String?> _mapToTextFieldValueState() => _$userDataEvent;
}
