part of 'error_model.dart';

class ServerErrorModel extends ErrorModel {
  ServerErrorModel([super.errorLogDetails]);

  String get message => S.current.server;

  @override
  String toString() => 'ServerError.';
}
