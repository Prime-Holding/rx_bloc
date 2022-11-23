part of 'error_model.dart';

class ErrorRequiredFieldModel<T> extends ErrorModel {
  ErrorRequiredFieldModel({
    required this.fieldKey,
    required this.fieldValue,
  });

  /// The translatable field key.
  final String fieldKey;

  final T fieldValue;

  @override
  String toString() =>
      'ErrorRequiredField. Key: $fieldKey. Value: $fieldValue.';
}
