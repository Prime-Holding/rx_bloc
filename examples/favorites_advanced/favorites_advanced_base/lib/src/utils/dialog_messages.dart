import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
          child: const Text(
            'No',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          color: Theme.of(context).buttonTheme.colorScheme!.primary,
        ),
        DialogButton(
          onPressed: () {
            onYesPressed?.call();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Yes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
      content: child ?? const SizedBox(),
    ).show();
