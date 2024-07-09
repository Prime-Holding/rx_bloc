part of 'error_model.dart';

class NotFoundErrorModel extends ErrorModel {
  NotFoundErrorModel({
    this.message,
    Map<String, String>? errorLogDetails,
  }) : super(errorLogDetails);

  final String? message;

  @override
  String toString() => 'NotFoundError. Message: $message.';
}
