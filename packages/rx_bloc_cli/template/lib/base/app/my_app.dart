import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/environment_config.dart';
import '../routers/router.gr.dart' as router;
import '../utils/providers.dart';

/// This widget is the root of your application.
class MyApp extends StatelessWidget {
  MyApp(this._envConfig);

  final EnvironmentConfig _envConfig;
  final _router = router.Router();

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: Providers.allProviders,
        child: _MyMaterialApp(_router),
      );
}

class _MyMaterialApp extends StatelessWidget {
  const _MyMaterialApp(this._router);
  final router.Router _router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'My app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routeInformationParser: _router.defaultRouteParser(),
        routerDelegate: _router.delegate(),
      );
}
