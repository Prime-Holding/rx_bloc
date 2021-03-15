import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_test/get_test.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:favorites_advanced_base/models.dart';


main() {
  // testController<NavbarController>("navbarContrller", (controller) {},
  //     controller: NavbarController(), onReady: (c) {
  //   c.items;
  // });
  group("NavigationBarController", () {
    test("return correct number of navbar items", () {
      final controller = Get.put(NavbarController());
      expect(controller.items.length, 2);
    });
    test("correct init navbar item", () {
      final controller = Get.put(NavbarController());
      expect(controller.selectedPage.type, NavigationItemType.search);
    });
    test("correct set navbar item", () {
      final controller = Get.put(NavbarController());
      controller.selectPage(NavigationItemType.favorites);
      expect(controller.selectedPage.type, NavigationItemType.favorites);
    });
    test("return correct navbar item search as title", () {
      final controller = Get.put(NavbarController());
      expect(controller.title, 'Search for Puppies');
    });
    test("return correct navbar item favorite as title", () {
      final controller = Get.put(NavbarController());
      controller.selectPage(NavigationItemType.favorites);
      expect(controller.title, 'Favorites Puppies');
    });
  });
}

