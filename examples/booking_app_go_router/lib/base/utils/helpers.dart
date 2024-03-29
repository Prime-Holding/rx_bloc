// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.


import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Runs a function inside an environment safe from exceptions
Future safeRun(Function action) async {
  try {
    await action();
  } catch (e) {
    log('Safe Error: $e');
  }
}

/// Shows a dialog that adjusts to the target operating system
Future<T?> showAdaptiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? label,
  RouteSettings? routeSettings,
  bool dismissible = true,
  bool useRootNavigator = true,
}) async {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  if (isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: builder,
      barrierDismissible: dismissible,
      barrierLabel: label,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
    );
  }
  return showDialog(
    context: context,
    builder: builder,
    barrierDismissible: dismissible,
    barrierLabel: label,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
  );
}
