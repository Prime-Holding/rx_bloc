import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required Exception error,
    Key? key,
  })  : _error = error,
        super(key: key);

  final Exception _error;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(_error.toString()),
      );
}
