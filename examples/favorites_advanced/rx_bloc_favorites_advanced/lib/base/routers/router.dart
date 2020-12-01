import 'package:auto_route/auto_route_annotations.dart';

import '../../feature_home/views/home_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: HomePage, initial: true),
  ],
)
class $MyRouter {}
