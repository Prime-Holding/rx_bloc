{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';{{#enable_remote_translations}}
import 'util.dart';{{/enable_remote_translations}}

class AppI18nLibChangeLanguageLookup extends I18nLibChangeLanguageLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) { {{#enable_remote_translations}}
    return getFromNetwork('lib_changelanguage__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;{{/enable_remote_translations}}{{^enable_remote_translations}}
    return getFromBundle(AppI18n.locale?.languageCode)
        .getString(key, placeholders)!;{{/enable_remote_translations}}
  }

  I18nLibChangeLanguage? bundledI18n;

  I18nLibChangeLanguage getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nLibChangeLanguage(I18nLibChangeLanguageLookup_bg());
          break;
        case 'en':
        default:
          bundledI18n = I18nLibChangeLanguage(I18nLibChangeLanguageLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
