{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/language_picker.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../data_sources/language_local_data_source.dart';
import '../data_storages/language_picker_shared_preferences_instance.dart';
import '../services/language_service_example.dart';

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
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: padding ?? 25,
    ),
    child: OutlineFillButton(
      text: buttonText ?? _buttonText,
      onPressed: () => showChangeLanguageBottomSheet(
        context: context,
        service: service ??
            LanguageServiceExample(
              localDataSource: LanguageLocalDataSource(
                LanguagePickerSharedPreferencesInstance(),
              ),
            ),
        onChanged: onChanged ?? (model) => print('onChanged: $model'),
        translate: translate ?? (model) => 'translate your model: $model',
      ),
    ),
  );
}

