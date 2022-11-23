part of 'error_model.dart';

class ErrorUnknownModel extends ErrorModel {
  ErrorUnknownModel({
    this.error,
    this.exception,
  });

  factory ErrorUnknownModel.fromString(String data) =>
      ErrorUnknownModel(exception: Exception(data));

  final Error? error;
  final Exception? exception;

  @override
  String toString() =>
      'Unknown Error. ${exception.toString()}; Error: ${error.toString()}';
}
