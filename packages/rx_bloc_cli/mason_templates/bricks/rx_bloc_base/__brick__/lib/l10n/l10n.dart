{{> licence.dart }}

import 'package:flutter/widgets.dart';

import '../assets.dart';

export  '../assets.dart' show I18n;

extension AppLocalizationsX on BuildContext {
  I18n get l10n => I18n.of(this);
}
