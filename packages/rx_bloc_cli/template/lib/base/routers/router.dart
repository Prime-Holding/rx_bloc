import 'package:auto_route/auto_route.dart';
import 'package:flutter_rx_bloc_scaffold/feature_counter/views/home_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: HomePage, initial: true),
  ],
)
class $Router {}
