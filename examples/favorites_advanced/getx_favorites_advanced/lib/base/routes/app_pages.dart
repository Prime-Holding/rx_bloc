import 'package:get/get.dart';

import 'file:///C:/Users/snezh/AndroidStudioProjects/rx_bloc/examples/favorites_advanced/getx_favorites_advanced/lib/feature_home/bindings/home_binding.dart';
import 'package:getx_favorites_advanced/feature_home/views/home_page.dart';

part 'app_routes.dart';

class AppPages{
  static const initial = Routes.home;
  
  static final routes = [
    GetPage(name: Routes.home, page: () => HomePage(), binding: HomeBinding()),
  ];

}