part of 'error_model.dart';

class ErrorFieldRequiredModel<T> extends ErrorModel {
  ErrorFieldRequiredModel({
    required this.fieldKey,
    required this.fieldValue,
  });

  /// The translatable field key.
  final String fieldKey;

  final T fieldValue;

  @override
  String toString() =>
      'ErrorFieldRequiredModel. Key: $fieldKey. Value: $fieldValue.';
}
