part of 'error_model.dart';

class FieldErrorModel<T> extends ErrorModel {
  FieldErrorModel({
    required this.fieldKey,
    required this.fieldValue,
  });

  /// The translatable field key.
  final String fieldKey;

  final T fieldValue;

  @override
  String toString() => 'FieldError. Key: $fieldKey. Value: $fieldValue.';
}
