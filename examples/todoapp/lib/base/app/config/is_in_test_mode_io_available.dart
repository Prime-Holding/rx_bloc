import 'dart:io';

bool isInTestModePlatformSpecific = Platform.environment.containsKey('FLUTTER_TEST');