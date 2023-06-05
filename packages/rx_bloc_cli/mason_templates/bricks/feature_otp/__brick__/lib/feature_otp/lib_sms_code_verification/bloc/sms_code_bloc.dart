import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';
import '../../../base/extensions/error_model_extensions.dart';
import '../../../base/models/errors/error_model.dart';
import '../../../base/models/temporary_code_state.dart';
import '../../lib_countdown_widget/services/countdown_service.dart';
import '../services/sms_code_service.dart';

part 'sms_code_bloc.rxb.g.dart';
part 'sms_code_bloc_extensions.dart';

abstract class SmsCodeBlocEvents {
  /// Edit user's phone number where codes will be send
  void updatePhoneNumber(String number);

  void getPhoneNumber();

  /// Check if the entered code is equal to the sent one
  void verifyCode(String tempCode);

  /// Initiates new code sending
  void sendNewCode();

  /// Forward the result from code verification in the service.
  void setResult(dynamic result);

  /// Triggers the current state of the code field
  void setTemporaryCodeState(TemporaryCodeState state);

  /// Reset bought counters - validity and resendButtonThrottleTime to their initial
  /// value. If stopCounter is true, set the [resendButtonThrottleTime] to zero
  void reset({bool stopCounter = false});

  /// Triggers to true for a while if a new code have been sent successfully
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: false)
  void codeSent(bool isSent);

  /// When the [resendButtonThrottleTime] past, the resend button needs to know
  /// that, so its state can be triggered back to enabled, but without any
  /// influence of the validity counter
  void enableResendButton();
}

abstract class SmsCodeBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  /// The user's number where codes are being sent
  Stream<String> get phoneNumber;

  /// The period while the lately sent code will be valid, in seconds
  Stream<int> get validityTime;

  ///The period while the resend button will be disabled, in seconds
  Stream<int> get resendButtonThrottleTime;

  /// Sending new code will be disabled for certain amount of time after each
  /// successful sending,in order to prevent users from spamming the server
  Stream<Result<bool>> get isSendNewCodeEnabled;

  /// Triggers true for a few seconds after a new code have been sent.
  /// Use it to display success state of the resend button.
  Stream<bool> get sentNewCode;

  /// Hold different predefines states of the code field. Used to display
  /// different labels above the code field
  Stream<TemporaryCodeState> get onCodeVerificationResult;

  /// Retrieve the result of the code verification from the service.
  /// The user can define its type on implementing the SmsCodeService
  Stream<dynamic> get result;

  /// Hold the number of expected length of the code
  Stream<int> get pinLength;
}

@RxBloc()
class SmsCodeBloc extends $SmsCodeBloc {
  SmsCodeBloc(this._coordinatorBlocType,
      {required SmsCodeService service,
      required CountdownService countdownService,
      String? initialPhoneNumber,
      this.sentNewCodeActivationTime = 3})
      : _service = service,
        _countDownService = countdownService,
        _initialPhoneNumber = initialPhoneNumber {
    if (_initialPhoneNumber != null) {
      _number.add(_initialPhoneNumber!);
    } else {
      _$getPhoneNumberEvent
          .startWith(null)
          .switchMap((_) => _service.getFullPhoneNumber().asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .bind(_number)
          .addTo(_compositeSubscription);
    }
  }

  final SmsCodeService _service;
  final CountdownService _countDownService;
  final String? _initialPhoneNumber;
  final int sentNewCodeActivationTime;
  final CoordinatorBlocType _coordinatorBlocType;
  final BehaviorSubject<String> _number = BehaviorSubject<String>();

  @override
  Stream<String> _mapToPhoneNumberState() => _number;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<Result<bool>> _mapToIsSendNewCodeEnabledState() => Rx.merge([
        resendButtonThrottleTime.map((event) => event <= 0).asResultStream(),
        _$sendNewCodeEvent
            .withLatestFrom<String, String>(phoneNumber, (t, s) => s)
            .switchMap(
                (value) => _service.sendConfirmationSms(value).asResultStream())
            .resetAfterCodeSent(this),
        _$updatePhoneNumberEvent
            .switchMap((value) => _service.updatePhoneNumber(value).asStream())
            .doOnData((event) => _number.add(event))
            .switchMap(
                (value) => _service.sendConfirmationSms(value).asResultStream())
            .resetAfterCodeSent(this),
        onCodeVerificationResult
            .where((event) => event == TemporaryCodeState.correct)
            .mapTo(true)
            .emitOtpConfirmedToCoordinator(_coordinatorBlocType)
            .asResultStream()
      ]);

  @override
  Stream<int> _mapToValidityTimeState() => _$resetEvent
      .startWith(false)
      .switchMap((value) => _service.getValidityTime(value).asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .switchMap((time) => _countDownService.countDown(maxTime: time).takeUntil(
          onCodeVerificationResult
              .where((event) => event == TemporaryCodeState.correct)));

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<TemporaryCodeState> _mapToOnCodeVerificationResultState() => Rx.merge([
        _$verifyCodeEvent
            .flatMap((value) => confirmSMSCode(value).asResultStream())
            .setResultStateHandler(this)
            .whereSuccess(),
        _$resetEvent
            .where((event) => !event)
            .map((val) => TemporaryCodeState.reset),
        _$setTemporaryCodeStateEvent.startWith(TemporaryCodeState.reset),
        validityTime
            .where((event) => event == 0)
            .map((event) => TemporaryCodeState.disabled),
      ]).shareReplay(maxSize: 1);

  @override
  Stream _mapToResultState() => _$setResultEvent;

  @override
  Stream<bool> _mapToSentNewCodeState() => _$codeSentEvent
      .startWith(false)
      .switchAfterSeconds(sentNewCodeActivationTime);

  @override
  Stream<int> _mapToPinLengthState() => _service
      .getCodeLength()
      .asResultStream()
      .setResultStateHandler(this)
      .whereSuccess()
      .asBroadcastStream()
      .shareReplay(maxSize: 1);

  @override
  Stream<int> _mapToResendButtonThrottleTimeState() => Rx.merge([
        _$resetEvent
            .startWith(false)
            .switchMap((event) =>
                _service.getResendButtonThrottleTime(event).asResultStream())
            .setResultStateHandler(this)
            .whereSuccess()
            .switchMap((time) => _countDownService.countDown(maxTime: time)),
        _$enableResendButtonEvent.mapTo(0)
      ]).asBroadcastStream();
}
