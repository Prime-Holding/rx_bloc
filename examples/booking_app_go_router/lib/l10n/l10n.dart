// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import 'package:flutter/widgets.dart';

import '../assets.dart';

export  '../assets.dart' show I18n;

extension AppLocalizationsX on BuildContext {
  I18n get l10n => I18n.of(this);
}
