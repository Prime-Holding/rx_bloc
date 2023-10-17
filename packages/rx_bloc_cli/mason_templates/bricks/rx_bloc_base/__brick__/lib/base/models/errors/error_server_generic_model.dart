part of 'error_model.dart';

class ErrorServerGenericModel extends ErrorModel {
  ErrorServerGenericModel({this.message, Map<String, String>? errorLogDetails})
      : super(errorLogDetails);

  final String? message;

  @override
  String toString() => 'ErrorServerGenericModel{message: $message}';
}
