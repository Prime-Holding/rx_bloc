part of 'error_model.dart';

class NotFoundErrorModel extends ErrorModel {
  NotFoundErrorModel({this.message});

  final String? message;

  @override
  String toString() => 'NotFoundError. Message: $message.';
}
