import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/local/translations_local_data_source.dart';
import '../models/i18n/i18n_models.dart';

class TranslationsRepository extends TranslationsDataSource {
  TranslationsRepository(this._errorMapper, this._dataSource);

  final ErrorMapper _errorMapper;
  final TranslationsDataSource _dataSource;

  @override
  Future<I18nSections?> getTranslations() =>
      _errorMapper.execute(_dataSource.getTranslations);
}
