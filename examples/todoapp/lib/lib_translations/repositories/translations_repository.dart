// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../../base/utils/no_connection_handle_mixin.dart';
import '../data_sources/local/translations_local_data_source.dart';
import '../data_sources/translations_data_source.dart';
import '../models/i18n_models.dart';

class TranslationsRepository extends TranslationsDataSource
    with NoConnectionHandlerMixin {
  TranslationsRepository(
      this._dataSource, this._errorMapper, this._localDataSource);

  final TranslationsDataSource _dataSource;
  final ErrorMapper _errorMapper;
  final TranslationsLocalDataSource _localDataSource;

  @override
  Future<I18nSections?> getTranslations() => _errorMapper.execute(() async {
        final translations = await _dataSource.getTranslations();
        await _localDataSource.saveTranslations(translations);
        return translations;
      }).onError((error, stackTrace) =>
          handleError(error, _localDataSource.getTranslations()));
}
