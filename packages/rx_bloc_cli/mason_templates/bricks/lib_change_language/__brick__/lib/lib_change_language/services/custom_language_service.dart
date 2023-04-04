{{> licence.dart }}

import 'package:widget_toolkit/language_picker.dart';

import '../repositories/language_repository.dart';

/// Example implementation of the LanguageService
class CustomLanguageService extends LanguageService {
  CustomLanguageService({
    required LanguageRepository languageRepository,
  }) : _languageRepository = languageRepository;

  final LanguageRepository _languageRepository;

  @override
  Future<List<LanguageModel>> getAll() async =>
      await _languageRepository.getAll();

  @override
  Future<LanguageModel> getCurrent() async =>
      await _languageRepository.getCurrent();

  @override
  Future<void> setCurrent(LanguageModel language) async =>
      await _languageRepository.setCurrent(language);
}
