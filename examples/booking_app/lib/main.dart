import 'package:booking_app/base/config/environment_config.dart';
import 'package:flutter/material.dart';

import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp(config: EnvironmentConfig.local));
}
