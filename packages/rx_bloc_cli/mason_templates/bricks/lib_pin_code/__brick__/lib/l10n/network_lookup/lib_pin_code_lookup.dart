{{> licence.dart}}

import '../../assets.dart';
import '../{{project_name}}_app_i18n.dart';
import 'util.dart';

class AppI18nLibPinCodeLookup extends I18nLibPinCodeLookup {
  @override
  String getString(String key, [Map<String, String>? placeholders]) {
    return getFromNetwork('lib_pincode__', key, placeholders) ??
        getFromBundle(AppI18n.locale?.languageCode)
            .getString(key, placeholders)!;
  }

  I18nLibPinCode? bundledI18n;

  I18nLibPinCode getFromBundle(String? languageCode) {
    if (bundledI18n == null) {
      switch (I18n.currentLocale?.languageCode) {
        case 'bg':
          bundledI18n = I18nLibPinCode(I18nLibPinCodeLookup_bg());
          break;
        case 'en':
          bundledI18n = I18nLibPinCode(I18nLibPinCodeLookup_en());
          break;
        default:
          bundledI18n = I18nLibPinCode(I18nLibPinCodeLookup_en());
          break;
      }
    }
    return bundledI18n!;
  }
}
