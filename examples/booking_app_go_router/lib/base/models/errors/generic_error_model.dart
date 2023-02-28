part of 'error_model.dart';

class GenericErrorModel extends ErrorModel implements L10nErrorKeyProvider {
  GenericErrorModel(this.l10nErrorKey);

  @override
  final String l10nErrorKey;

  @override
  String toString() => 'GenericError. TranslationKey: $l10nErrorKey';
}
