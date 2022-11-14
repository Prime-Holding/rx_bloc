part of 'error_model.dart';

class ErrorGenericModel extends ErrorModel {
  ErrorGenericModel(this.translationKey);

  final String translationKey;

  @override
  String toString() => 'ErrorGeneric. TranslationKey: $translationKey';
}
