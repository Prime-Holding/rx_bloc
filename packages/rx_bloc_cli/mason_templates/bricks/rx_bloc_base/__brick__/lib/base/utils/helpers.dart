{{> licence.dart }}

import 'dart:developer';

/// Runs a function inside an environment safe from exceptions
Future safeRun(Function action) async {
  try {
    await action();
  } catch (e) {
    log('Safe Error: $e');
  }
}
