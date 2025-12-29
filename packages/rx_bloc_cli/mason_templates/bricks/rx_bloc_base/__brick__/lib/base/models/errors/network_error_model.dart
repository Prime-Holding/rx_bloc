part of 'error_model.dart';

class NetworkErrorModel extends ErrorModel implements L10nErrorKeyProvider {
  NetworkErrorModel([super.errorLogDetails]);

  @override
  String get l10nErrorKey => S.current.network;

  @override
  String toString() => 'NetworkError.';
}
