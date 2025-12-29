part of 'error_model.dart';

class FieldRequiredErrorModel<T> extends ErrorModel {
  FieldRequiredErrorModel({
    required this.errorValue,
    required this.fieldValue,
    Map<String, String>? errorLogDetails,
  }) : super(errorLogDetails);

  /// The translatable field key.
  final String errorValue;

  final T fieldValue;

  @override
  String toString() =>
      'FieldRequiredError. Key: $errorValue. Value: $fieldValue.';
}
