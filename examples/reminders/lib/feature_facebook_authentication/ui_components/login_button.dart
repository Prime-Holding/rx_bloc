import 'package:flutter/material.dart';

import '../../base/common_ui_components/app_progress_indicator.dart';

/// Custom outlined button used on the login page. Displays a text inside it
/// when [loading] is set to false, or a loading indicator otherwise.
/// Has a customizable [color] property which sets the color of the outline of
/// the button and the [text] as well.
class LoginButton extends StatelessWidget {
  const LoginButton({
    required this.color,
    required this.text,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  /// The color of the button outline and the text
  final Color color;

  /// The text to be presented when the button is not in its loading state
  final String text;

  /// Callback triggered once the button has been pressed
  final VoidCallback onPressed;

  /// Flag indicating whether or not the button is loading
  final bool loading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: GestureDetector(
          onTap: () {
            onPressed();
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(10),
            child: loading
                ? const AppProgressIndicator()
                : Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text,
                              style: TextStyle(color: color, fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      );
}
