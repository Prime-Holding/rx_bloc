part of 'error_model.dart';

class AccessDeniedErrorModel extends ErrorModel {
  AccessDeniedErrorModel([super.errorLogDetails]);

  String get message => S.current.accessDenied;

  @override
  String toString() => 'AccessDeniedError. Message: $message.';
}
