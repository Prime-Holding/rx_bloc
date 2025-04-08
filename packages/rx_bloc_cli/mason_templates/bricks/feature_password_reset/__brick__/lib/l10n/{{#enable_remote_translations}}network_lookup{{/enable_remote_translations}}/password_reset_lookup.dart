{{> licence.dart }}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nPasswordResetLookup extends I18nFeaturePasswordResetLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('password_reset__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeaturePasswordReset? bundledI18n;

  I18nFeaturePasswordReset getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n =
              I18nFeaturePasswordReset(I18nFeaturePasswordResetLookup_bg());
          break;
        case 'en':
        default:
          bundledI18n =
              I18nFeaturePasswordReset(I18nFeaturePasswordResetLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
