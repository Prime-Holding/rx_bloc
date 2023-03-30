{{> licence.dart }}

import 'package:widget_toolkit/language_picker.dart';

import '../data_sources/language_local_data_source.dart';

class LanguageUtil {
  static String toKey(LanguageModel model) {
    switch (model.key) {
      case 'bulgarian':
        return LanguageLocalDataSource.keyBG;
      case 'english':
        return LanguageLocalDataSource.keyEN;
      default:
        return LanguageLocalDataSource.keyEN;
    }
  }
}
