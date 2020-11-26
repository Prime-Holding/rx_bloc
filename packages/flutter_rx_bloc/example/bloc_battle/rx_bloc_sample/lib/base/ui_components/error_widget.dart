import 'package:flutter/material.dart';

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
