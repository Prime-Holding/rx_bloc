import 'package:flutter/material.dart';

import '../../base/common_ui_components/app_progress_indicator.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    required this.color,
    required this.text,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final Color color;
  final String text;
  final VoidCallback onPressed;
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
