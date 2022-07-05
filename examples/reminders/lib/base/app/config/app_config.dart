import 'package:flutter/material.dart';

import 'environment_config.dart';

class AppConfig extends InheritedWidget {
  const AppConfig({ this.config = EnvironmentConfig.prod,
    required Widget child,Key? key}) :super(child: child,key: key);

  final EnvironmentConfig config;


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AppConfig? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: AppConfig);
}