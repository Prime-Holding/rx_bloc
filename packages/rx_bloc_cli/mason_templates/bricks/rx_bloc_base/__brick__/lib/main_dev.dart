{{> licence.dart }}

import 'package:flutter/material.dart';

import 'base/app/config/environment_config.dart';
import 'base/app/initialization/app_setup.dart';
import 'base/app/{{project_name}}.dart';{{#enable_dev_menu}}
import 'lib_dev_menu/ui_components/app_dev_menu.dart';
import 'lib_dev_menu/ui_components/dev_menu_bottom_sheet.dart';{{/enable_dev_menu}}

/// Main entry point for the development environment
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const environment = EnvironmentConfig.development();

  await configureApp(environment);

  runApp({{^enable_dev_menu}}const{{/enable_dev_menu}} {{project_name.pascalCase()}}(
    config: environment,{{#enable_dev_menu}}
    createDebugMenuInstance: (context, widget, navKey) =>
        AppDevMenuGestureDetector.withDependencies(
      context,
      navKey,
      child: widget,
      onDevMenuPresented: () {
        showAppDevMenuBottomSheet(
          navKey.currentContext!,
        );
      },
    ),
{{/enable_dev_menu}}
  ));
}
