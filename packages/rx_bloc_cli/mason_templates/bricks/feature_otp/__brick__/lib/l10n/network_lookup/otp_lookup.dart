{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nOtpLookup extends I18nFeatureOtpLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('otp__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeatureOtp? bundledI18n;

  I18nFeatureOtp getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nFeatureOtp(I18nFeatureOtpLookup_bg());
          break;
        case 'en':
          bundledI18n = I18nFeatureOtp(I18nFeatureOtpLookup_en());
          break;
        default:
          bundledI18n = I18nFeatureOtp(I18nFeatureOtpLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
