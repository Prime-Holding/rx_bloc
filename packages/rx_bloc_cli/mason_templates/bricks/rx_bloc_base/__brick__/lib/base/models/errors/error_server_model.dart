part of 'error_model.dart';

class ErrorServerModel extends ErrorModel implements L10nErrorKeyProvider {
  @override
  String get l10nErrorKey => I18nErrorKeys.server;

  @override
  String toString() => 'ErrorServer.';
}
