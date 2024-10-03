import 'package:flutter/material.dart';
import 'package:{{project_name}}/base/common_ui_components/custom_app_bar.dart';

import '../../../helpers/golden_helper.dart';
import '../../../helpers/models/scenario.dart';
import '../../stubs.dart';

void main() {
  runGoldenTests([
    generateDeviceBuilder(
      widget: Builder(builder: (context) => customAppBar(context)),
      scenario: Scenario(name: 'custom_app_bar_empty'),
    ),
    generateDeviceBuilder(
      widget: Builder(
          builder: (context) =>
              customAppBar(context, title: Stubs.appBarTitle)),
      scenario: Scenario(name: 'custom_app_bar_with_title'),
    ),
    generateDeviceBuilder(
      widget: Builder(
          builder: (context) => customAppBar(context,
              title: Stubs.appBarTitle, centerTitle: true)),
      scenario: Scenario(name: 'custom_app_bar_with_centered_title'),
    ),
    generateDeviceBuilder(
      widget: Builder(
          builder: (context) => customAppBar(context,
                  title: Stubs.appBarTitle,
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: Stubs.addIcon,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Stubs.removeIcon,
                      onPressed: () {},
                    ),
                  ])),
      scenario:
          Scenario(name: 'custom_app_bar_with_centered_title_and_actions'),
    ),
    generateDeviceBuilder(
      widget: Builder(
          builder: (context) =>
              customAppBar(context, title: Stubs.appBarTitle, actions: [
                IconButton(
                  icon: Stubs.addIcon,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Stubs.removeIcon,
                  onPressed: () {},
                ),
              ])),
      scenario: Scenario(name: 'custom_app_bar_with_title_and_actions'),
    ),
    generateDeviceBuilder(
      widget: Builder(
          builder: (context) => customAppBar(context, actions: [
                IconButton(
                  icon: Stubs.addIcon,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Stubs.removeIcon,
                  onPressed: () {},
                ),
              ])),
      scenario: Scenario(name: 'custom_app_bar_with_actions'),
    ),
  ]);
}
