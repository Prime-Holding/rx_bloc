// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:widget_toolkit/language_picker.dart';

import '../../base/data_sources/local/shared_preferences_instance.dart';
import '../utils/language_util.dart';

class LanguageLocalDataSource {
  static const keyCurrent = 'languageCurrent';
  static const keyBG = 'languageCurrentBG';
  static const keyEN = 'languageCurrentEN';
  static const showErrorValue = 'showError';

  LanguageLocalDataSource(this._storage);

  final SharedPreferencesInstance _storage;

  Future<List<LanguageModel>> getAll() async => [
        LanguageModel(
          locale: 'bg',
          key: 'bulgarian',
          languageCode: 'bg',
        ),
        LanguageModel(
          locale: 'en',
          key: 'english',
          languageCode: 'en',
        )
      ];

  Future<LanguageModel> getCurrent() async {
    final storedLanguage = (await _storage.getString(keyCurrent)) ?? keyEN;
    return _LanguageModelX.fromKey(storedLanguage);
  }

  Future<void> setCurrent(LanguageModel language) async =>
      await _storage.setString(keyCurrent, LanguageUtil.toKey(language));
}

extension _LanguageModelX on LanguageModel {
  static LanguageModel fromKey(String key) {
    if (key == LanguageLocalDataSource.keyBG) {
      return LanguageModel(
        locale: 'bg',
        key: 'bulgarian',
        languageCode: 'bg',
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
      locale: 'en',
      key: 'english',
      languageCode: 'en',
    );
  }
}
