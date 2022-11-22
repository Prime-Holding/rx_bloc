part of 'error_model.dart';

class ErrorNetworkModel extends ErrorModel implements L10nErrorKeyProvider {
  @override
  String get l10nErrorKey => I18nErrorKeys.network;

  @override
  String toString() => 'ErrorNetwork.';
}
