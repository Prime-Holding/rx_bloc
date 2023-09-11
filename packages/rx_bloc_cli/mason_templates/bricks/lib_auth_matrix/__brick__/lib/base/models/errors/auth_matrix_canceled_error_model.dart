{{> licence.dart }}

part of 'error_model.dart';

class AuthMatrixCanceledErrorModel extends ErrorModel
    implements L10nErrorKeyProvider {
  @override
  String get l10nErrorKey => I18nFeatureAuthMatrixKeys.authMatrixCancel;

  @override
  String toString() => 'AuthMatrixCanceledErrorModel';
}
