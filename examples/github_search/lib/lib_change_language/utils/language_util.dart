// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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
