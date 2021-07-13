import 'package:flutter/material.dart';

import 'base/config/environment_config.dart';
import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp(config: EnvironmentConfig.firebaseAlgolia));
}
