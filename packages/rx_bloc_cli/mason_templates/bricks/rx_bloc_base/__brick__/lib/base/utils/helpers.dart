import 'package:flutter/material.dart';

/// Runs a function inside an environment safe from exceptions
Future safeRun(Function action) async {
  try {
    await action();
  } catch (e) {
    debugPrint('Safe Error: $e');
  }
}
