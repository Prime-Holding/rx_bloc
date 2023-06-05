import 'package:flutter/material.dart';

/// Use this class to translate all labels used in the package. If not
/// overridden, default values in English will be used.
class LocalizedStrings {
  LocalizedStrings(this.context);
  LocalizedStrings._(this.context);

  factory LocalizedStrings.of(context) =>
      _instance != null ? _instance! : _instance = LocalizedStrings._(context);

  static LocalizedStrings? _instance;

  final BuildContext context;

  /// Text displayed during the enabled state of the button
  String get resendButtonActiveStateLabel => 'Resend code';

  /// Text displayed while sending a code
  String get resendButtonLoadingStateLabel => 'Sending code';

  /// Text displayed if the sent code was successful
  String get resendButtonCodeSentStateLabel => 'Code was sent';

  /// Text used for displaying an error message
  String get resendButtonErrorStateLabel =>
      'An error occurred while sending code';

  /// Text displayed while the button is in the disabled state
  String get resendButtonDisabledStateLabel => 'Seconds to enable the button';

  /// Validity widget title, by default 'Code validity'
  String get codeValidity => 'Code validity';

  /// By default 'An error occurred. try again.'
  String get smsCodeResendError => 'An error occurred. try again.';

  /// By default 'Send New Code'
  String get sendNewCode => 'Send New Code';

  /// By default 'The code has been sent'
  String get codeSent => 'The code has been sent';

  /// By default 'Minutes'
  String get minutes => 'Minutes';

  /// By default 'VALID CODE!'
  String get codeStateCorrect => 'VALID CODE!';

  /// By default 'WRONG CODE'
  String get codeStateWrong => 'WRONG CODE';

  /// By default 'Your time has expired, please submit a new code'
  String get codeStateDisabled =>
      'Your time has expired, please submit a new code';

  /// By default 'Enter the received SMS code'
  String get codeStateDefault => 'Enter the received SMS code';
}

extension LocalizedStringsContextExtension on BuildContext {
  LocalizedStrings get getLocalizedStrings => LocalizedStrings.of(this);
}
