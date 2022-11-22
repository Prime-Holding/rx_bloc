part of 'error_model.dart';

class ErrorAccessDeniedModel extends ErrorModel
    implements L10nErrorKeyProvider {
  @override
  String get l10nErrorKey => I18nErrorKeys.accessDenied;

  @override
  String toString() => 'ErrorAccessDenied.';
}
