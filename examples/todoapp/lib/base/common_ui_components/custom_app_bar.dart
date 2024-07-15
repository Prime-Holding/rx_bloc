// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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
