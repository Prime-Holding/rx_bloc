import 'package:get/get.dart';

import 'package:getx_favorites_advanced/feature_home/bindings/home_binding.dart';
import 'package:getx_favorites_advanced/feature_home/views/home_page.dart';
import 'package:getx_favorites_advanced/feature_puppy/details/bindings/details_binding.dart';
import 'package:getx_favorites_advanced/feature_puppy/details/views/details_page.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/bindings/edit_bindings.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/views/edit_page.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;
  static const details = Routes.details;
  static const edit = Routes.edit;

  static final routes = [
    GetPage(name: Routes.home, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
        name: Routes.details,
        page: () => DetailsPage(),
        binding: DetailsBinding()),
    GetPage(name: Routes.edit, page: () => EditPage(), binding: EditBindings()),
  ];
}
