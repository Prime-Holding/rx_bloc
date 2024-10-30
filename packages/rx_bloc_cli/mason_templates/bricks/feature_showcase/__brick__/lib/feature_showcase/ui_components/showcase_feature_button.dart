{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';

class ShowcaseFeatureButton extends StatelessWidget {
  const ShowcaseFeatureButton(
      {super.key, required this.onPressed, required this.buttonText});

  final void Function() onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.designSystem.spacing.xs),
      child: OutlineFillButton(
        text: buttonText,
        onPressed: onPressed,
      ),
    );
  }
}
