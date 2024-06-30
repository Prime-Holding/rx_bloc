import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../lib_router/router.dart';
import '../di/dev_menu_dependencies.dart';
import 'app_dev_menu_gesture_detector.dart';
import 'dev_menu_bottom_sheet.dart';

class AppDevMenuGestureDetectorWithDependencies extends StatelessWidget {
  const AppDevMenuGestureDetectorWithDependencies({
    required this.child,
    this.navigatorKey,
    super.key,
  });

  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: DevMenuDependencies.from(context).providers,
        child: AppDevMenuGestureDetector(
          onDevMenuPresented: () {
            showAppDevMenuBottomSheet(
              AppRouter.rootNavigatorKey.currentContext!,
            );
          },
          navigatorKey: navigatorKey,
          child: child,
        ),
      );
}
