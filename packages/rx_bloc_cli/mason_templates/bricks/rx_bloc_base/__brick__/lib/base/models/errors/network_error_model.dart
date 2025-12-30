part of 'error_model.dart';

class NetworkErrorModel extends ErrorModel {
  NetworkErrorModel([super.errorLogDetails]);

  String get message => S.current.network;

  @override
  String toString() => 'NetworkError.';
}
