// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../extensions/error_model_translations.dart';
import '../models/errors/error_model.dart';
import 'primary_button.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.error,
    required this.onTabRetry,
    Key? key,
  }) : super(key: key);

  final Exception error;
  final Function() onTabRetry;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text((error as ErrorModel).translate(context)),
      SizedBox(height: context.designSystem.spacing.l),
      PrimaryButton(
        onPressed: onTabRetry,
        child: Text(context.l10n.tryAgain),
      ),
    ],
  );
}
