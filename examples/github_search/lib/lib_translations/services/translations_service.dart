// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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
