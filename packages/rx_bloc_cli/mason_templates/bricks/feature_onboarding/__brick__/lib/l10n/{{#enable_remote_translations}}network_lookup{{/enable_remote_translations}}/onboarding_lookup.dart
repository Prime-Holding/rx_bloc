{{> licence.dart }}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nOnboardingLookup extends I18nFeatureOnboardingLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('onboarding__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeatureOnboarding? bundledI18n;

  I18nFeatureOnboarding getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nFeatureOnboarding(I18nFeatureOnboardingLookup_bg());
          break;
        case 'en':
        default:
          bundledI18n = I18nFeatureOnboarding(I18nFeatureOnboardingLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
