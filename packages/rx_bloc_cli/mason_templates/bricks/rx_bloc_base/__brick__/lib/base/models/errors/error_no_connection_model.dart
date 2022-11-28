part of 'error_model.dart';

class ErrorNoConnectionModel extends ErrorModel
    implements L10nErrorKeyProvider {
  @override
  String get l10nErrorKey => I18nErrorKeys.noConnection;

  @override
  String toString() => 'ErrorNoConnection.';
}
