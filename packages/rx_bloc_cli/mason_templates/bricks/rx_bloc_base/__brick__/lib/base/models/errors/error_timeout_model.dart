part of 'error_model.dart';

class ErrorTimeoutModel extends ErrorModel {
  ErrorTimeoutModel({this.message, Map<String, String>? errorLogDetails})
      : super(errorLogDetails);

  final String? message;

  @override
  String toString() => 'ErrorTimeoutModel{message: $message}';
}
