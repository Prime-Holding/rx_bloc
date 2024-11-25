{{> licence.dart }}

import 'package:flutter/widgets.dart';
{{#enable_remote_translations}}
import '{{project_name}}_app_i18n.dart';{{/enable_remote_translations}}{{^enable_remote_translations}}
import '../assets.dart';{{/enable_remote_translations}}

extension AppLocalizationsX on BuildContext { {{#enable_remote_translations}}
  AppI18n get l10n => AppI18n.of(this);{{/enable_remote_translations}}{{^enable_remote_translations}}
  I18n get l10n => I18n.of(this);{{/enable_remote_translations}}
}
