{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';{{#enable_remote_translations}}
import 'util.dart';{{/enable_remote_translations}}

class AppI18nDeepLinkLookup extends I18nFeatureDeepLinkLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) { {{#enable_remote_translations}}
    return getFromNetwork('deeplink__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;{{/enable_remote_translations}}{{^enable_remote_translations}}
    return getFromBundle(AppI18n.locale?.languageCode)
        .getString(key, placeholders)!;{{/enable_remote_translations}}
  }

  I18nFeatureDeepLink? bundledI18n;

  I18nFeatureDeepLink getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nFeatureDeepLink(I18nFeatureDeepLinkLookup_bg());
          break;
        case 'en':
        default:
          bundledI18n = I18nFeatureDeepLink(I18nFeatureDeepLinkLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
