part of 'error_model.dart';

class ErrorFormFieldModel<T> extends ErrorModel {
  ErrorFormFieldModel({
    required this.translationKey,
    required this.fieldValue,
  });

  /// The translatable key
  final String translationKey;

  final T fieldValue;
}
