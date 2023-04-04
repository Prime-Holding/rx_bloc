{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/language_picker.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../di/change_language_with_dependencies.dart';
import '../services/custom_language_service.dart';

class LanguagePickerButton extends StatelessWidget {
  const LanguagePickerButton({
    this.service,
    this.onChanged,
    this.translate,
    this.padding,
    this.buttonText,
    super.key,
  });

  final LanguageService? service;
  final void Function(LanguageModel)? onChanged;
  final String Function(LanguageModel)? translate;
  final double? padding;
  final String? buttonText;
  static const String _buttonText = 'Change Language';
  static const _bulgarian = 'bulgarian';

  @override
  Widget build(BuildContext context) => ChangeLanguageWithDependencies(
        child: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: padding ?? 25,
            ),
            child: OutlineFillButton(
              text: buttonText ?? _buttonText,
              onPressed: () => showChangeLanguageBottomSheet(
                context: context,
                service: service ?? context.read<CustomLanguageService>(),
                onChanged: onChanged ?? (model) => {},
                translate: translate ??
                    (model) => model.key == _bulgarian
                        ? context.l10n.libChangeLanguage.bulgarian
                        : context.l10n.libChangeLanguage.english,
              ),
            ),
          ),
        ),
      );
}
