// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../lib_translations/services/translations_service.dart';
import '../todo_app_i18n.dart';

String? getFromNetwork(
  String screen,
  String key,
  Map<String, String>? placeholders, {
  String separator = '_',
}) {
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
      var containsTranslation =
          translation?.containsKey('$screen$separator$key');

      if (containsTranslation != null && containsTranslation) {
        var result = translation!['$screen$separator$key']!;
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
