import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:favorites_advanced_base/models.dart';


void main() {
  group('NavigationBarController', () {
    final controller = Get.put(NavbarController());
    test('return correct number of navbar items', () {
      expect(controller!.items.length, 2);
    });
    test('correct init navbar item', () {
      expect(controller!.selectedPage.type, NavigationItemType.search);
    });
    test('correct set navbar item', () {
      controller!.selectPage(NavigationItemType.favorites);
      expect(controller.selectedPage.type, NavigationItemType.favorites);
    });
    test('return correct navbar item search as title', () {
      controller!.selectPage(NavigationItemType.search);
      expect(controller.title, 'Search for Puppies');
    });
    test('return correct navbar item favorite as title', () {
      controller!.selectPage(NavigationItemType.favorites);
      expect(controller.title, 'Favorites Puppies');
    });
  });
}

