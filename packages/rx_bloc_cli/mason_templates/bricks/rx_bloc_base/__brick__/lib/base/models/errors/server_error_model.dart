part of 'error_model.dart';

class ServerErrorModel extends ErrorModel implements L10nErrorKeyProvider {
  ServerErrorModel([super.errorLogDetails]);

  @override
  String get l10nErrorKey => I18nErrorKeys.server;

  @override
  String toString() => 'ServerError.';
}
