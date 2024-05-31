// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/cupertino.dart';
import 'package:widget_toolkit/language_picker.dart';

import '../../app_extensions.dart';

extension LanguageModelX on LanguageModel {
  String asText(BuildContext context) {
    switch (locale) {
      case 'bg':
        return context.l10n.bulgarian;
      default:
        return context.l10n.english;
    }
  }
}
