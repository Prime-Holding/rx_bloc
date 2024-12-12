{{> licence.dart }}

import 'package:open_mail/open_mail.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/count_down_service.dart';
import '../../base/common_services/open_mail_app_service.dart';
import '../../base/common_services/users_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';

part 'onboarding_email_confirmation_bloc.rxb.g.dart';

/// A contract class containing all events of the OnboardingEmailConfirmationBloC.
abstract class OnboardingEmailConfirmationBlocEvents {
  void initialize();

  void startConfirmPin();

  void openMailClient(String noMailAppFoundTitle);

  void disableSendNewLink();

  void sendNewLink();

  void openMockDeepLinkSuccess();
  void openMockDeepLinkError();
}

/// A contract class containing all states of the OnboardingEmailConfirmationBloC.
abstract class OnboardingEmailConfirmationBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  Stream<List<MailApp>> get openMailApp;

  Stream<String> get email;

  Stream<bool> get isSendNewLinkActive;
}

@RxBloc()
class OnboardingEmailConfirmationBloc extends $OnboardingEmailConfirmationBloc {
  OnboardingEmailConfirmationBloc(
    this._email,
    this._openMailAppService,
    this._usersService,
    this._countDownService,
  ) {
    _$openMockDeepLinkSuccessEvent
        .switchMap(
            (_) => _usersService.openMockEmailSuccessLink().asResultStream())
        .setResultStateHandler(this)
        .listen((_) {})
        .addTo(_compositeSubscription);

    _$openMockDeepLinkErrorEvent
        .switchMap(
            (_) => _usersService.openMockEmailErrorLink().asResultStream())
        .setResultStateHandler(this)
        .listen((_) {})
        .addTo(_compositeSubscription);
  }

  final String _email;
  final OpenMailAppService _openMailAppService;
  final UsersService _usersService;
  final CountDownService _countDownService;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<List<MailApp>> _mapToOpenMailAppState() => _$openMailClientEvent
      .switchMap(
          (title) => _openMailAppService.openMailApp(title).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess();

  @override
  Stream<String> _mapToEmailState() => _$sendNewLinkEvent
      .switchMap((value) => _resendConfirmationEmail().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .startWith(_email);

  static const countDownSeconds = 10;

  @override
  Stream<bool> _mapToIsSendNewLinkActiveState() =>
      _$disableSendNewLinkEvent.switchMap((value) => _countDownService
          .startCountDown(countDown: countDownSeconds)
          .map((event) => event > 0));

  Future<String> _resendConfirmationEmail() async {
    final user = await _usersService.resendConfirmationEmail();
    _$disableSendNewLinkEvent.add(null);
    return user.email;
  }
}
