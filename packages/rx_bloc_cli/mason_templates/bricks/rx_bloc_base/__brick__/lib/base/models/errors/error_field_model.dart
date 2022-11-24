part of 'error_model.dart';

class ErrorFieldModel<T> extends ErrorModel {
  ErrorFieldModel({
    required this.fieldKey,
    required this.fieldValue,
  });

  /// The translatable field key.
  final String fieldKey;

  final T fieldValue;

  @override
  String toString() => 'ErrorFieldModel. Key: $fieldKey. Value: $fieldValue.';
}
