{{> licence.dart }}

import 'package:flutter/widgets.dart';

import '{{project_name}}_app_i18n.dart';

extension AppLocalizationsX on BuildContext {
  AppI18n get l10n => AppI18n.of(this);
}
