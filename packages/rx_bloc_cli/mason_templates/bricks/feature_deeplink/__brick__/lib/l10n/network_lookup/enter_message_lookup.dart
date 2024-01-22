{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nEnterMessageLookup extends I18nFeatureEnterMessageLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('enter_message__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeatureEnterMessage? bundledI18n;

  I18nFeatureEnterMessage getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n =
              I18nFeatureEnterMessage(I18nFeatureEnterMessageLookup_bg());
          break;
        case 'en':
          bundledI18n =
              I18nFeatureEnterMessage(I18nFeatureEnterMessageLookup_en());
          break;
        default:
          bundledI18n =
              I18nFeatureEnterMessage(I18nFeatureEnterMessageLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
