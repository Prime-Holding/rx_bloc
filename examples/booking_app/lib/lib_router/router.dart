// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../feature_home/di/home_page_with_dependencies.dart';
import '../feature_hotel_details/di/hotel_details_with_dependencies.dart';
import 'models/route_data_model.dart';
import 'models/routes_path.dart';
import 'views/error_page.dart';

part 'router.g.dart';
part 'routes/routes.dart';

class AppRouter {
  AppRouter();

  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    initialLocation: const HomeRoutes(NavigationItemType.search).location,
    routes: $appRoutes,
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(
        error: state.error,
      ),
    ),
  );
}
