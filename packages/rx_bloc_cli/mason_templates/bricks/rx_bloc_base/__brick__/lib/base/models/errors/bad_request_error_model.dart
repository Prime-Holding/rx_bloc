part of 'error_model.dart';

class BadRequestErrorModel extends ErrorModel {
  BadRequestErrorModel({
    this.message,
    Map<String, String>? errorLogDetails,
  }) : super(errorLogDetails);

  final String? message;

  @override
  String toString() => 'BadRequestError. Message: $message.';
}
