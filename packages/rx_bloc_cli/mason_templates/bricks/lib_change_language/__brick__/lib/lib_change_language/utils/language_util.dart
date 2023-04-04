{{> licence.dart }}

import 'package:widget_toolkit/language_picker.dart';

import '../repositories/language_repository.dart';

class LanguageUtil {
  static String toKey(LanguageModel model) {
    switch (model.key) {
      case 'bulgarian':
        return LanguageRepository.keyBG;
      case 'english':
        return LanguageRepository.keyEN;
      default:
        return LanguageRepository.keyEN;
    }
  }
}
