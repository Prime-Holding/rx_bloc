{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nTFALookup extends I18nFeatureTfaLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('tfa__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeatureTfa? bundledI18n;

  I18nFeatureTfa getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nFeatureTfa(I18nFeatureTfaLookup_bg());
          break;
        case 'en':
          bundledI18n = I18nFeatureTfa(I18nFeatureTfaLookup_en());
          break;
        default:
          bundledI18n = I18nFeatureTfa(I18nFeatureTfaLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
