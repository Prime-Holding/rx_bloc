import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}/feature_counter/views/home_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: HomePage, initial: true),
  ],
)
class $Router {}
