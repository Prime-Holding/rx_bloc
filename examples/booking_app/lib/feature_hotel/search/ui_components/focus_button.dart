import 'package:flutter/material.dart';

class FocusButton extends StatelessWidget {
  FocusButton({
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            onPressed();
          },
          child: child,
        ),
      );
}
