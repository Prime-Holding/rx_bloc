// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

{{#analytics}}
import 'package:firebase_analytics/observer.dart';
{{/analytics}}
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../di/app_dependencies.dart';
import '../routers/router.gr.dart' as router;
import '../theme/design_system.dart';
import 'config/environment_config.dart';

/// This widget is the root of your application.
class {{#pascalCase}}{{project_name}}{{/pascalCase}} extends StatelessWidget {
  {{#pascalCase}}{{project_name}}{{/pascalCase}}({this.config = EnvironmentConfig.prod});

  final EnvironmentConfig config;
  final _router = router.Router();

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: AppDependencies.of(context).providers,
        child: _MyMaterialApp(_router),
      );
}

class _MyMaterialApp extends StatelessWidget {
  const _MyMaterialApp(this._router);

  final router.Router _router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: '{{#titleCase}}{{project_name}}{{/titleCase}}',
        theme: DesignSystem.fromBrightness(Brightness.light).theme,
        darkTheme: DesignSystem.fromBrightness(Brightness.dark).theme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: _router.defaultRouteParser(),
        routerDelegate: _router.delegate({{#analytics}}
          navigatorObservers: () => [
            context.read<FirebaseAnalyticsObserver>(),
          ],
        {{/analytics}}),
        debugShowCheckedModeBanner: false,
      );
}
