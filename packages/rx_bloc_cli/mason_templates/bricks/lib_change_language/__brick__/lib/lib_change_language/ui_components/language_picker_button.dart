{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/language_picker.dart';

import '../../base/common_ui_components/app_list_tile.dart';
import '../../base/theme/design_system.dart';
import '../extensions/language_model_extensions.dart';
import '../services/app_language_service.dart';

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

  @override
  Widget build(BuildContext context) => AppListTile(
        featureTitle: buttonText ?? _buttonText,
        icon: context.designSystem.icons.language,
        onTap: () => showChangeLanguageBottomSheet(
          context: context,
          service: service ?? context.read<AppLanguageService>(),
          onChanged: onChanged ?? (model) => {},
          translate: translate ?? (model) => model.asText(context),
        ),
      );
}
