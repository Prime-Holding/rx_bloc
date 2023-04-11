{{> licence.dart }}

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
