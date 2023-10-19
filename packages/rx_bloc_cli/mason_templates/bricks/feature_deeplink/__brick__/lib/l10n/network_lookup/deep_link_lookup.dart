{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nDeepLinkLookup extends I18nFeatureDeepLinkLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('deeplink__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeatureDeepLink? bundledI18n;

  I18nFeatureDeepLink getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nFeatureDeepLink(I18nFeatureDeepLinkLookup_bg());
          break;
        case 'en':
          bundledI18n = I18nFeatureDeepLink(I18nFeatureDeepLinkLookup_en());
          break;
        default:
          bundledI18n = I18nFeatureDeepLink(I18nFeatureDeepLinkLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
