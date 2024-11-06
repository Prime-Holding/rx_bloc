{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nErrorLookup extends I18nErrorLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('error__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nError? bundledI18n;

  I18nError getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nError(I18nErrorLookup_bg());
          break;
        case 'en':
        default:
          bundledI18n = I18nError(I18nErrorLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
