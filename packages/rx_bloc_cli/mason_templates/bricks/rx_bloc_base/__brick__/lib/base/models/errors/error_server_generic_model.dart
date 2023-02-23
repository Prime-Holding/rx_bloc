part of 'error_model.dart';

class ErrorServerGenericModel extends ErrorModel {
  ErrorServerGenericModel({this.message});

  final String? message;

  @override
  String toString() => 'ErrorServerGenericModel{message: $message}';
}
