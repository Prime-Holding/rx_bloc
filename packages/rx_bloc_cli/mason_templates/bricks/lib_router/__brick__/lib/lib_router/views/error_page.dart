{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.error,
    super.key,
  });

  final Exception? error;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.appBarText),
        ),
        body: Center(
          child: error == null
              ? Text(context.l10n.errorOccurred)
              : Text(context.l10n.error(error.toString())),
        ),
      );
}
