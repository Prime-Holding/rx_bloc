// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';

import 'todoapp_app_i18n.dart';

extension AppLocalizationsX on BuildContext {
  AppI18n get l10n => AppI18n.of(this);
}
