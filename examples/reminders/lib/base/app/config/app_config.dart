import 'package:flutter/material.dart';

import 'environment_config.dart';

/// The app config class containing the current environment configuration
class AppConfig extends InheritedWidget {
  /// AppConfig constructor taking in the [config] and a [child] widget
  const AppConfig({
    this.config = EnvironmentConfig.prod,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  /// The current environment configuration
  final EnvironmentConfig config;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  /// Static method to retrieve the app config from the provided [context]
  static AppConfig? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConfig>();
}
