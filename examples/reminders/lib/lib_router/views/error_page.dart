// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

/// Page presenting an error message once the user tries to navigate to
/// a non-existent page or an error happens along the way
class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.error,
    super.key,
  });

  final Exception? error;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error page!'),
        ),
        body: Center(
          child: error != null
              ? Text('Error message: ${error.toString()}')
              : const Text('Error message.'),
        ),
      );
}
