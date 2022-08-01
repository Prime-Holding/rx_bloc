import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const LoginButton({
    required this.color,
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

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
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(color: color, fontSize: 18),
                      ),
                      const SizedBox(width: 35),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
