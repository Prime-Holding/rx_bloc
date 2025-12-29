part of 'error_model.dart';

class ConnectionRefusedErrorModel extends ErrorModel
    implements L10nErrorKeyProvider {
  ConnectionRefusedErrorModel([super.errorLogDetails]);

  @override
  String get l10nErrorKey => S.current.connectionRefused;

  @override
  String toString() => 'ConnectionRefusedError.';
}
