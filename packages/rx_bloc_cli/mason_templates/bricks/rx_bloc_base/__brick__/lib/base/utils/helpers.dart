// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

/// Runs a function inside an environment safe from exceptions
Future safeRun(Function action) async {
  try {
    await action();
  } catch (e) {
    debugPrint('Safe Error: $e');
  }
}
