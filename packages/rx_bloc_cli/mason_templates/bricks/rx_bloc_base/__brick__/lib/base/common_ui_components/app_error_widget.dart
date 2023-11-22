{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../extensions/error_model_translations.dart';
import '../models/errors/error_model.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.error,
    required this.onTabRetry,
    super.key,
  });

  final Exception error;
  final Function() onTabRetry;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (error as ErrorModel).translate(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.designSystem.spacing.l),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: OutlineFillButton(
              onPressed: onTabRetry,
              text: context.l10n.tryAgain,
            ),
          ),
        ],
      );
}
