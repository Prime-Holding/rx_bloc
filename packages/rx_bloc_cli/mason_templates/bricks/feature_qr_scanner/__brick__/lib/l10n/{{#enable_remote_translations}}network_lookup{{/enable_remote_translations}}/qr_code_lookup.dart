{{> licence.dart }}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nQrLookup extends I18nFeatureQrLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('qrCode__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nFeatureQr? bundledI18n;

  I18nFeatureQr getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nFeatureQr(I18nFeatureQrLookup_bg());
          break;
        case 'en':
        default:
          bundledI18n = I18nFeatureQr(I18nFeatureQrLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
