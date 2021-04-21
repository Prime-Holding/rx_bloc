// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

{{#analytics}}
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
{{/analytics}}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../l10n/l10n.dart';
import '../routers/router.gr.dart' as router;
import '../utils/global_providers.dart';
import 'environment_config.dart';

/// This widget is the root of your application.
class {{#pascalCase}}{{project_name}}{{/pascalCase}} extends StatelessWidget {
  {{#pascalCase}}{{project_name}}{{/pascalCase}}({this.config = EnvironmentConfig.prod});

  final EnvironmentConfig config;
  final _router = router.Router();

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: GlobalProviders.of(context).providers,
        child: _MyMaterialApp(_router),
      );
}

class _MyMaterialApp extends StatelessWidget {
  const _MyMaterialApp(this._router);

  final router.Router _router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: '{{#titleCase}}{{project_name}}{{/titleCase}}',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: _router.defaultRouteParser(),
        routerDelegate: _router.delegate({{#analytics}}
          navigatorObservers: [
            Provider.of<FirebaseAnalyticsObserver>(context, listen: false),
          ],
        {{/analytics}}),
      );
}
