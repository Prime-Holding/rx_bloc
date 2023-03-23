{{> licence.dart }}

import 'package:widget_toolkit/language_picker.dart';

import '../data_sources/language_local_data_source.dart';

/// Example implementation of the LanguageService
class LanguageServiceExample extends LanguageService {
  LanguageServiceExample({
    required LanguageLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final LanguageLocalDataSource _localDataSource;

  @override
  Future<List<LanguageModel>> getAll() async => await _localDataSource.getAll();

  @override
  Future<LanguageModel> getCurrent() async =>
      await _localDataSource.getCurrent();

  @override
  Future<void> setCurrent(LanguageModel language) async =>
      await _localDataSource.setCurrent(language);
}
