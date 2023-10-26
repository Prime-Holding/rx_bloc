{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nAuthMatrixLookup extends I18nFeatureAuthMatrixLookup {

  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('auth_matrix__', key, placeholders) ??
    getFromBundle(AppI18n.locale?.languageCode)
        .getString(key, placeholders)!;
  }

  I18nFeatureAuthMatrix? bundledI18n;

  I18nFeatureAuthMatrix getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nFeatureAuthMatrix(I18nFeatureAuthMatrixLookup_bg());
        break;
        case 'en':
          bundledI18n = I18nFeatureAuthMatrix(I18nFeatureAuthMatrixLookup_en());
        break;
        default:
          bundledI18n = I18nFeatureAuthMatrix(I18nFeatureAuthMatrixLookup_en());
        break;
      }
    }
    return bundledI18n!;
  }
}
