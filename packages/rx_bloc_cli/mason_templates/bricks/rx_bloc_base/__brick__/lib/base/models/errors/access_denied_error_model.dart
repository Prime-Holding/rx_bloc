part of 'error_model.dart';

class AccessDeniedErrorModel extends ErrorModel
    implements L10nErrorKeyProvider {
  AccessDeniedErrorModel([super.errorLogDetails]);

  @override
  String get l10nErrorKey => I18nErrorKeys.accessDenied;

  @override
  String toString() => 'AccessDeniedError.';
}
