part of 'error_model.dart';

class FieldRequiredErrorModel<T> extends ErrorModel {
  FieldRequiredErrorModel({
    required this.fieldKey,
    required this.fieldValue,
  });

  /// The translatable field key.
  final String fieldKey;

  final T fieldValue;

  @override
  String toString() =>
      'FieldRequiredError. Key: $fieldKey. Value: $fieldValue.';
}
