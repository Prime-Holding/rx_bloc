{{> licence.dart }}

import '../models/i18n_models.dart';
import '../repositories/translations_repository.dart';

class TranslationsService {
  TranslationsService(this._repository);

  final TranslationsRepository _repository;
  static I18nSections? translations;

  Future<I18nSections?> _getTranslations({bool force = false}) async {
    if (translations == null || force) {
      translations = await _repository.getTranslations();
    }

    return translations;
  }

  /// Load translations
  Future<void> load() async {
    await _getTranslations(force: true);
  }
}
