part of 'error_model.dart';

class BadRequestErrorModel extends ErrorModel implements L10nErrorKeyProvider {
  BadRequestErrorModel([this.message, super.errorLogDetails]);

  final String? message;

  @override
  String get l10nErrorKey => I18nErrorKeys.accessDenied;

  @override
  String toString() => 'BadRequestError. Message: $message.';
}
