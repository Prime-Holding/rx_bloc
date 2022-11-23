part of 'error_model.dart';

class ErrorNotFoundModel extends ErrorModel {
  ErrorNotFoundModel({this.message});

  final String? message;

  @override
  String toString() => 'ErrorNotFound. Message: $message.';
}
