{{> licence.dart }}

import 'package:widget_toolkit/widget_toolkit.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';
import '../models/language_model_example.dart';
import '../utils/language_util.dart';

/// Example for a language data source implementation
class LanguageLocalDataSource {
  static const keyCurrent = 'languageCurrent';
  static const keyES = 'languageCurrentES';
  static const keyEN = 'languageCurrentEN';
  static const showErrorValue = 'showError';

  LanguageLocalDataSource(this._storage);

  final SharedPreferencesInstance _storage;

  Future<List<LanguageModel>> getAll() async => [
        LanguageModelExample(
          locale: 'es',
          key: 'spanish',
          languageCode: 'es',
        ),
        LanguageModelExample(
          locale: 'en',
          key: 'english',
          languageCode: 'en',
        )
      ];

  Future<LanguageModel> getCurrent() async {
    final storedLanguage = (await _storage.getString(keyCurrent)) ?? keyEN;
    // throw Exception();
    return _LanguageModelX.fromKey(storedLanguage);
  }

  Future<void> setCurrent(LanguageModel language) async {
    await _storage.setString(keyCurrent, LanguageUtil.toKey(language));
  }

}

extension _LanguageModelX on LanguageModel {
  static LanguageModel fromKey(String key) {
    if (key == LanguageLocalDataSource.keyES) {
      return LanguageModelExample(
        locale: 'es',
        key: 'spanish',
        languageCode: 'es',
      );
    }

    if (key == LanguageLocalDataSource.keyEN) {
      return LanguageModelExample(
        locale: 'en',
        key: 'english',
        languageCode: 'en',
      );
    }

    return LanguageModelExample(
      locale: 'es',
      key: 'spanish',
      languageCode: 'es',
    );
  }
}
