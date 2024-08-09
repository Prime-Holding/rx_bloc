import 'dart:io';

/// Please use the variable from [app_constants.dart]
/// This file isn't meant to be used as a main source of its contents.
bool isInTestMode = Platform.environment.containsKey('FLUTTER_TEST');
