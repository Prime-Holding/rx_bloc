{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nNotificationsLookup extends I18nFeatureNotificationsLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('notifications__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeatureNotifications? bundledI18n;

  I18nFeatureNotifications getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n =
              I18nFeatureNotifications(I18nFeatureNotificationsLookup_bg());
          break;
        case 'en':
          bundledI18n =
              I18nFeatureNotifications(I18nFeatureNotificationsLookup_en());
          break;
        default:
          bundledI18n =
              I18nFeatureNotifications(I18nFeatureNotificationsLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
