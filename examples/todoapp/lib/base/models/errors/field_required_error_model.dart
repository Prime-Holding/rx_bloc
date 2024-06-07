part of 'error_model.dart';

class FieldRequiredErrorModel<T> extends ErrorModel {
  FieldRequiredErrorModel({
    required this.fieldKey,
    required this.fieldValue,
    Map<String, String>? errorLogDetails,
  }) : super(errorLogDetails);

  /// The translatable field key.
  final String fieldKey;

  final T fieldValue;

  @override
  String toString() =>
      'FieldRequiredError. Key: $fieldKey. Value: $fieldValue.';
}
