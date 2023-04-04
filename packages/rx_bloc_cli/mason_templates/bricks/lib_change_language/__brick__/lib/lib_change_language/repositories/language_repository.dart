{{> licence.dart }}

import 'package:widget_toolkit/language_picker.dart';

import '../data_sources/language_local_data_source.dart';

class LanguageRepository {
  LanguageRepository({
    required LanguageLocalDataSource languageLocalDataSource,
  }) : _languageLocalDataSource = languageLocalDataSource;

  final LanguageLocalDataSource _languageLocalDataSource;

  Future<List<LanguageModel>> getAll() async =>
      await _languageLocalDataSource.getAll();

  Future<LanguageModel> getCurrent() async =>
      await _languageLocalDataSource.getCurrent();

  Future<void> setCurrent(LanguageModel language) async =>
      await _languageLocalDataSource.setCurrent(language);
}
