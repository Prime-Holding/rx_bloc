part of 'sms_code_bloc.dart';

extension ConfirmSMSCodeFromEmail on SmsCodeBloc {
  Stream<TemporaryCodeState> confirmSMSCode(String code) async* {
    try {
      yield TemporaryCodeState.loading;

      var confirmPhoneCode = await _service.confirmPhoneCode(code);
      setResult(confirmPhoneCode);

      yield TemporaryCodeState.correct;
      return;
    } catch (e) {
      codeSent(false);
      setTemporaryCodeState(TemporaryCodeState.wrong);
      rethrow;
    }
  }
}

extension CodeSent on Stream<bool> {
  Stream<bool> switchAfterSeconds(int seconds) => switchMap((event) async* {
        if (event) {
          yield true;
          await Future.delayed(Duration(seconds: seconds));
          yield false;
        } else {
          yield false;
        }
      });
}

extension SideEffects on Stream<Result<bool>> {
  Stream<Result<bool>> resetAfterCodeSent(SmsCodeBloc bloc) =>
      doOnData((event) {
        if (event is ResultSuccess) {
          bloc.codeSent(true);
          bloc.reset.call();
        }
      });
}
