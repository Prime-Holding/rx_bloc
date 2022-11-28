part of 'error_model.dart';

class ConnectionRefusedErrorModel extends ErrorModel
    implements L10nErrorKeyProvider {
  @override
  String get l10nErrorKey => I18nErrorKeys.connectionRefused;

  @override
  String toString() => 'ConnectionRefusedError.';
}
