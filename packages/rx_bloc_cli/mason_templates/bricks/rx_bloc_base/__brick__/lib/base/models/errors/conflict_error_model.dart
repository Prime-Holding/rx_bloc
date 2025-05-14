part of 'error_model.dart';

class ConflictErrorModel extends ErrorModel {
  ConflictErrorModel({
    this.message,
    Map<String, String>? errorLogDetails,
  }) : super(errorLogDetails);

  final String? message;

  @override
  String toString() => 'ConflictErrorModel. Message: $message.';
}
