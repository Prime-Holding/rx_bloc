import 'package:flutter/material.dart';

/// TODO: Move that widget to the favorites_advanced_base package
class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({Key key, this.onReloadTap}) : super(key: key);

  final VoidCallback onReloadTap;

  @override
  Widget build(BuildContext context) => Center(
        child: RaisedButton(
          child: const Text('Try again'),
          onPressed: onReloadTap,
        ),
      );
}
