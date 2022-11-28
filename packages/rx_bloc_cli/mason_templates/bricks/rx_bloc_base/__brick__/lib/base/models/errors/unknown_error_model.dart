part of 'error_model.dart';

class UnknownErrorModel extends ErrorModel {
  UnknownErrorModel({
    this.error,
    this.exception,
  });

  factory UnknownErrorModel.fromString(String data) =>
      UnknownErrorModel(exception: Exception(data));

  final Error? error;
  final Exception? exception;

  @override
  String toString() =>
      'UnknownError. ${exception.toString()}; Error: ${error.toString()}';
}
