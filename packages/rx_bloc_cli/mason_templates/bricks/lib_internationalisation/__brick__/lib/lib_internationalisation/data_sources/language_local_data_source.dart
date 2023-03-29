{{> licence.dart }}

import 'package:widget_toolkit/language_picker.dart';

import '../data_storages/language_picker_shared_preferences_instance.dart';
import '../utils/language_util.dart';

/// Example for a language data source implementation
class LanguageLocalDataSource {
  static const keyCurrent = 'languageCurrent';
  static const keyES = 'languageCurrentES';
  static const keyEN = 'languageCurrentEN';
  static const showErrorValue = 'showError';

  LanguageLocalDataSource(this._storage);

  final LanguagePickerSharedPreferencesInstance _storage;

  Future<List<LanguageModel>> getAll() async => [
        LanguageModel(
          locale: 'es',
          key: 'spanish',
          languageCode: 'es',
        ),
        LanguageModel(
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
      return LanguageModel(
        locale: 'es',
        key: 'spanish',
        languageCode: 'es',
      );
    }

    if (key == LanguageLocalDataSource.keyEN) {
      return LanguageModel(
        locale: 'en',
        key: 'english',
        languageCode: 'en',
      );
    }

    return LanguageModel(
      locale: 'es',
      key: 'spanish',
      languageCode: 'es',
    );
  }
}
