// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../assets.dart';
import '../todoapp_app_i18n.dart';
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
