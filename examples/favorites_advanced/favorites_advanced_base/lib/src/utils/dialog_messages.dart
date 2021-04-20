import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../core.dart';

Widget alertAnimation(Animation<double> animation, Widget child) =>
    FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.slowMiddle,
      ),
      child: child,
    );

Future<void> showYesNoMessage({
  required BuildContext context,
  required String title,
  VoidCallback? onYesPressed,
  VoidCallback? onNoPressed,
  Widget? child,
}) async =>
    await Alert(
      context: context,
      onWillPopActive: true,
      alertAnimation: (context, animation, secondaryAnimation, child) =>
          alertAnimation(animation, child),
      title: title,
      buttons: [
        DialogButton(
          onPressed: () {
            onNoPressed?.call();
            Navigator.of(context).pop();
          },
          child: Text(
            'No',
            style: DesignSystem.of(context).typography.alertSecondaryTitle,
          ),
          color: DesignSystem.of(context).colors.buttonColor,
        ),
        DialogButton(
          onPressed: () {
            onYesPressed?.call();
            Navigator.of(context).pop();
          },
          child: Text(
            'Yes',
            style: DesignSystem.of(context).typography.alertPrimaryTitle,
          ),
        ),
      ],
      content: child ?? const SizedBox(),
    ).show();
