import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
      title: title,
      buttons: [
        DialogButton(
          onPressed: () {
            onYesPressed?.call();
            Navigator.of(context).pop();
          },
          color: Colors.red,
          child: const Text(
            'Yes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        DialogButton(
          onPressed: () {
            onNoPressed?.call();
            Navigator.of(context).pop();
          },
          child: const Text(
            'No',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
      content: child ?? const SizedBox(),
    ).show();
