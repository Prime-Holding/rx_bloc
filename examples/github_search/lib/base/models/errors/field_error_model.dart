part of 'error_model.dart';

class FieldErrorModel<T> extends ErrorModel {
  FieldErrorModel({
    required this.errorKey,
    required this.fieldValue,
    Map<String, String>? errorLogDetails,
  }) : super(errorLogDetails);

  /// The translatable error key.
  final String errorKey;

  final T fieldValue;

  @override
  String toString() => 'FieldError. Key: $errorKey. Value: $fieldValue.';
}
