{{> licence.dart }}

import 'package:flutter/widgets.dart';

import 'testapp_localization_app_i18n.dart';

extension AppLocalizationsX on BuildContext {
  AppI18n get l10n => AppI18n.of(this);
}
