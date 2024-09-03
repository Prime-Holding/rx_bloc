// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../base/utils/no_connection_handle_mixin.dart';
import '../data_sources/translations_data_source.dart';
import '../models/i18n_models.dart';

class TranslationsRepository extends TranslationsDataSource
    with NoConnectionHandlerMixin, NoConnectionHandlerMixin {
  TranslationsRepository(this._dataSource, this._errorMapper);

  final TranslationsDataSource _dataSource;
  final ErrorMapper _errorMapper;

  @override
  Future<I18nSections?> getTranslations() =>
      _errorMapper.execute(() => _dataSource.getTranslations()).onError(
            (error, stackTrace) => handleError(error, null),
          );
}
