import 'package:flutter/material.dart';

/// Wrapper widget around the [Text] used on the login page
class LoginText extends StatelessWidget {
  const LoginText({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
          fontWeight: FontWeight.w600),
    );
  }
}
