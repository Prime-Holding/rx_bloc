{{> licence.dart }}

import 'package:flutter/material.dart';

AppBar customAppBar(
    BuildContext context, {
      String? title,
      List<Widget>? actions,
      bool centerTitle = false,
    }) =>
    AppBar(
      title: title != null ? Text(title) : null,
      actions: actions,
      centerTitle: centerTitle,
    );
