import 'package:flutter/material.dart';

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
