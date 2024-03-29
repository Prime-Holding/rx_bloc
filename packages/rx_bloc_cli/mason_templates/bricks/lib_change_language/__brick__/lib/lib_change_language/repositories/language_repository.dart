{{> licence.dart }}

import 'package:widget_toolkit/language_picker.dart';

import '../../base/common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/language_local_data_source.dart';

class LanguageRepository {
  LanguageRepository(
    this._errorMapper,
    this._languageLocalDataSource,
  );

  final ErrorMapper _errorMapper;
  final LanguageLocalDataSource _languageLocalDataSource;

  Future<List<LanguageModel>> getAll() =>
      _errorMapper.execute(() => _languageLocalDataSource.getAll());

  Future<LanguageModel> getCurrent() =>
      _errorMapper.execute(() => _languageLocalDataSource.getCurrent());

  Future<void> setCurrent(LanguageModel language) =>
      _errorMapper.execute(() => _languageLocalDataSource.setCurrent(language));
}
