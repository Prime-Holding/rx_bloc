import 'package:auto_route/auto_route_annotations.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/views/puppy_details_page.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/edit/views/puppy_edit_page.dart';

import '../../feature_home/views/home_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: HomePage, initial: true),
    MaterialRoute(page: PuppyDetailsPage),
    MaterialRoute(page: PuppyEditPage),
  ],
)
class $MyRouter {}
