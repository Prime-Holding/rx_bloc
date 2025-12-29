part of 'error_model.dart';

class FieldErrorModel<T> extends ErrorModel {
  FieldErrorModel({
    required this.errorValue,
    required this.fieldValue,
    Map<String, String>? errorLogDetails,
  }) : super(errorLogDetails);

  /// The translatable error key.
  final String errorValue;

  final T fieldValue;

  @override
  String toString() => 'FieldError. Key: $errorValue. Value: $fieldValue.';
}
