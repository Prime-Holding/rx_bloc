part of 'error_model.dart';

class NoConnectionErrorModel extends ErrorModel
    implements L10nErrorKeyProvider {
  NoConnectionErrorModel([super.errorLogDetails]);

  @override
  String get l10nErrorKey => I18nErrorKeys.noConnection;

  @override
  String toString() => 'NoConnectionError.';
}
