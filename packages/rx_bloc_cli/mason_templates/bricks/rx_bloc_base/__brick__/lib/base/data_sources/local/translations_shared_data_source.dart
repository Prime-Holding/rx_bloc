{{> licence.dart }}

import 'dart:convert';

import '../../models/i18n/i18n_models.dart';
import 'shared_preferences_instance.dart';
import 'translations_local_data_source.dart';

class TranslationsSharedDataSource extends TranslationsDataSource {
  TranslationsSharedDataSource(this._storage);

  final SharedPreferencesInstance _storage;

  @override
  Future<I18nSections?> getTranslations() =>
      _storage.getString('translations').then((value) =>
          value != null ? I18nSections.fromJson(jsonDecode(value)) : null);

  Future<Map<String, String>?> getTranslationsByLanguage(String language) =>
      _storage.getString('translations_$language').then((value) => value != null
          ? (jsonDecode(value) as Map<String, Object>).map(
              (key, value) => MapEntry<String, String>(key, value.toString()))
          : null);
}
