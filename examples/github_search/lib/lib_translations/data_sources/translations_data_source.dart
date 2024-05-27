// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../models/i18n_models.dart';

abstract class TranslationsDataSource {
  Future<I18nSections?> getTranslations();
}
