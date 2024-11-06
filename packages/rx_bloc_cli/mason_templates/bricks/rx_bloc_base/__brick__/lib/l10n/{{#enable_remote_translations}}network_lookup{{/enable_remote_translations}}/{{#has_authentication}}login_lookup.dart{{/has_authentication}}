{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nLoginLookup extends I18nFeatureLoginLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('login__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeatureLogin? bundledI18n;

  I18nFeatureLogin getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nFeatureLogin(I18nFeatureLoginLookup_bg());
          break;
        case 'en':
        default:
          bundledI18n = I18nFeatureLogin(I18nFeatureLoginLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
