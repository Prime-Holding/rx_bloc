// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:widget_toolkit/language_picker.dart';

import '../repositories/language_repository.dart';

/// Example implementation of the LanguageService
class AppLanguageService extends LanguageService {
  AppLanguageService({
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
