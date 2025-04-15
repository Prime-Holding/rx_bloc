{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../base/extensions/error_model_extensions.dart';
import '../../../../base/models/errors/error_model.dart';
import '../../base/common_services/count_down_service.dart';
import '../../base/common_services/open_mail_app_service.dart';
import '../../feature_password_reset_request/services/password_reset_request_service.dart';
import '../services/password_reset_confirmation_service.dart';

part 'password_reset_confirmation_bloc.rxb.g.dart';

const _countDownSeconds = 60;

/// A contract class containing all events of the PasswordResetConfirmationBloC.
abstract class PasswordResetConfirmationBlocEvents {
  /// Opens the mail client/selection dialog with the given [title]
  void openMailClient(String noMailAppFoundTitle);

  /// Disables the "Send new link" button
  void disableSendNewLink();

  /// Sends a new confirmation email
  void sendNewLink();

  /// Opens a fake email confirmation link with a success result
  /// Used for demo purposes, should be removed in a real app
  void openMockDeepLinkSuccess();

  /// Opens a fake email confirmation link with an error result
  /// Used for demo purposes, should be removed in a real app
  void openMockDeepLinkError();
}

/// A contract class containing all states of the PasswordResetConfirmationBloC.
abstract class PasswordResetConfirmationBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// State which returns a list of available email apps on the device
  ConnectableStream<void> get openMailApp;

  /// The email state
  Stream<String> get email;

  /// The state indicating whether the "Send new link" button is active
  Stream<bool> get isSendNewLinkActive;
}

@RxBloc()
class PasswordResetConfirmationBloc extends $PasswordResetConfirmationBloc {
  PasswordResetConfirmationBloc(
    this._email,
    this._openMailAppService,
    this._passwordResetRequestService,
    this._passwordResetConfirmationService,
    this._countDownService,
  ) {
    openMailApp.connect().addTo(_compositeSubscription);

    /// Used for demo purposes, should be removed in a real app
    Rx.merge([
      _$openMockDeepLinkErrorEvent.switchMap((_) =>
          _passwordResetConfirmationService
              .openMockEmailErrorLink(_email)
              .asResultStream()),
      _$openMockDeepLinkSuccessEvent.switchMap((_) =>
          _passwordResetConfirmationService
              .openMockEmailSuccessLink(_email)
              .asResultStream()),
    ]).setResultStateHandler(this).listen((_) {}).addTo(_compositeSubscription);
  }

  final String _email;
  final OpenMailAppService _openMailAppService;
  final PasswordResetRequestService _passwordResetRequestService;
  final PasswordResetConfirmationService _passwordResetConfirmationService;
  final CountDownService _countDownService;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  ConnectableStream<void> _mapToOpenMailAppState() => _$openMailClientEvent
      .switchMap((title) => _openMailAppService.openMailApp().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .publish();

  @override
  Stream<String> _mapToEmailState() => _$sendNewLinkEvent
      .switchMap((value) => _resendConfirmationEmail().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .startWith(_email);

  @override
  Stream<bool> _mapToIsSendNewLinkActiveState() => _$disableSendNewLinkEvent
      .startWith(null)
      .switchMap((value) => _countDownService
          .startCountDown(countDown: _countDownSeconds)
          .map((event) => event > 0));

  Future<String> _resendConfirmationEmail() async {
    await _passwordResetRequestService.requestPasswordReset(email: _email);
    disableSendNewLink();
    return _email;
  }
}
