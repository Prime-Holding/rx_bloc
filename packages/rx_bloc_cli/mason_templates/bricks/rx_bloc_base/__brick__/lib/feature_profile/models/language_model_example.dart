{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../l10n/l10n.dart';

/// TODO MOVE THE WHOLE FILE
class LanguageModelExample extends LanguageModel {
  LanguageModelExample(
      {required super.locale, required super.key, required super.languageCode});

  @override
  String translate(BuildContext context) {
    switch (locale) {
      case 'en':
        return context.l10n.english;
      case 'es':
        return context.l10n.spanish;
      default:
        return context.l10n.english;
    }
  }
}
