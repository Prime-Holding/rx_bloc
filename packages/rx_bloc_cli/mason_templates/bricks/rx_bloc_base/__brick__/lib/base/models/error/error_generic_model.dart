part of 'error_model.dart';

class ErrorGenericModel extends ErrorModel implements L10nErrorKeyProvider {
  ErrorGenericModel(this.l10nErrorKey);

  @override
  final String l10nErrorKey;

  @override
  String toString() => 'ErrorGeneric. TranslationKey: $l10nErrorKey';
}
