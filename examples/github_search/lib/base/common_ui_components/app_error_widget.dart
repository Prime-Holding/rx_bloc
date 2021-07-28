import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../extensions/exception_extensions.dart';
import '../theme/design_system.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required Exception error,
    this.onReloadPressed,
    Key? key,
  })  : _error = error,
        super(key: key);

  final Exception _error;
  final VoidCallback? onReloadPressed;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(8),
          // height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  _error.toMessage(),
                  style: context.designSystem.typography.bodyText1.copyWith(
                    color: context.designSystem.colors.errorColor,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onReloadPressed,
                child: Text(context.l10n.reload),
              )
            ],
          ),
        ),
      );
}
