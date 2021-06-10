import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/models.dart';

import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';

import '../../stubs.dart';


void main() {
  late NavbarController _controller;

  setUp((){
    Get.testMode = true;
    _controller = Get.put(NavbarController());
  });

  tearDown((){
    Get.delete<NavbarController>();
  });

  group('NavbarController - ', () {
    test('return correct number of navbar items', () {
      expect(_controller.items.length, 2);
    });

    test('correct init navbar item', () {
      expect(_controller.selectedPage, Stub.navigation.searchSelected);
      expect(_controller.items.contains(Stub.navigation.favoritesNotSelected),
          isTrue);
    });

    test('correct set navbar item', () {
      _controller.selectPage(NavigationItemType.favorites);
      expect(_controller.selectedPage, Stub.navigation.favoritesSelected);
      expect(_controller.items.contains(Stub.navigation.searchNotSelected),
          isTrue);
    });

    test('return correct navbar item search as title', () {
      _controller.selectPage(NavigationItemType.search);
      expect(_controller.title, Stub.navigation.searchTitle);
    });

    test('return correct navbar item favorite as title', () {
      _controller.selectPage(NavigationItemType.favorites);
      expect(_controller.title, Stub.navigation.favoritesTitle);
    });
  });
}

