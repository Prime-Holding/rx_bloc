{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';

PreferredSizeWidget pinCodeAppBar(
  BuildContext context, {
  required String title,
}) =>
    AppBar(
      title: Text(
        title,
        style: context.designSystem.typography.h1Reg22,
      ),
      foregroundColor: context.designSystem.colors.pinAppBarColor,
      forceMaterialTransparency: true,
    );
