{{> licence.dart }}

import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.error,
    Key? key,
  }) : super(key: key);

  final Exception? error;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error page!'),
        ),
        body: Center(
          child: error == null
              ? const Text('An error occurred.')
              : Text('Error: ${error.toString()}'),
        ),
      );
}
