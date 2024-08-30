import 'dart:convert';

import '../../../app_extensions.dart';
import '../../../base/data_sources/local/shared_preferences_instance.dart';
import '../../models/i18n_models.dart';
import '../translations_data_source.dart';

class TranslationsLocalDataSource implements TranslationsDataSource {
  TranslationsLocalDataSource(this.sharedPreferences);

  final SharedPreferencesInstance sharedPreferences;

  Future<bool> saveTranslations(I18nSections? translations) async {
    if (translations == null) {
      return sharedPreferences.setString(translationsKey, '');
    }
    final jsonString = json.encode(translations.toJson());
    return sharedPreferences.setString(translationsKey, jsonString);
  }

  @override
  Future<I18nSections?> getTranslations() async {
    final jsonString = await sharedPreferences.getString(translationsKey);
    if (jsonString != null) {
      return I18nSections.fromJson(json.decode(jsonString));
    } else {
      return null;
    }
  }
}
