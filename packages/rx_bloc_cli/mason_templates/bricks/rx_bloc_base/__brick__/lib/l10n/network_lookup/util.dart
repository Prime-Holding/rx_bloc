{{> licence.dart }}

import '../../base/common_services/translations_service.dart';
import '../{{project_name}}_app_i18n.dart';

String? getFromNetwork(
  String screen,
  String key,
  Map<String, String>? placeholders,
) {
  // Implemented to get the values from the network_lookup
  // Some additional null/key existence checks should be always present

  if (TranslationsService.translations != null) {
    // This language check may be optional if the loading of translations is
    // separated in different network requests
    var containsLanguage = TranslationsService.translations!.item
        .containsKey(AppI18n.locale?.languageCode);

    if (containsLanguage) {
      var translation =
          TranslationsService.translations!.item[AppI18n.locale?.languageCode];
      var containsTranslation = translation?.containsKey('${screen}_$key');

      if (containsTranslation != null && containsTranslation) {
        var result = translation!['${screen}_$key']!;
        if (placeholders != null) {
          placeholders.forEach((key, value) {
            result = result.replaceAll('{$key}', value);
          });
        }
        return result;
      }
    }
  }
  return null;
}
