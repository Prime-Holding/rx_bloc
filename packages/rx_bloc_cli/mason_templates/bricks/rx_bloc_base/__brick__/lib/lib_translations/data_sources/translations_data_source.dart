{{> licence.dart }}

import '../models/i18n_models.dart';

abstract class TranslationsDataSource {
  Future<I18nSections?> getTranslations();
}
