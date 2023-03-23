{{> licence.dart }}

import 'package:widget_toolkit/widget_toolkit.dart';

import '../data_sources/language_local_data_source.dart';

class LanguageUtil {
  static String toKey(LanguageModel model) {
    switch (model.key) {
      case 'spanish':
        return LanguageLocalDataSource.keyES;
      case 'english':
        return LanguageLocalDataSource.keyEN;
      default:
        return LanguageLocalDataSource.keyES;
    }
  }
}
