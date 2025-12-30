part of 'error_model.dart';

class NoConnectionErrorModel extends ErrorModel {
  NoConnectionErrorModel([super.errorLogDetails]);

  String get message => S.current.noConnection;

  @override
  String toString() => 'NoConnectionError.';
}
