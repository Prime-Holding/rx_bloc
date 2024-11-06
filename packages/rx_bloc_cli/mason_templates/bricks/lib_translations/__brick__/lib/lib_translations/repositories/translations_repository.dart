{{> licence.dart }}

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/translations_data_source.dart';
import '../models/i18n_models.dart';

class TranslationsRepository extends TranslationsDataSource {
  TranslationsRepository(this._dataSource, this._errorMapper);

  final TranslationsDataSource _dataSource;
  final ErrorMapper _errorMapper;

  @override
  Future<I18nSections?> getTranslations() =>
      _errorMapper.execute(_dataSource.getTranslations);
}
