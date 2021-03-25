import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/resources.dart';

import 'package:getx_favorites_advanced/base/ui_components/puppies_app_bar.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/views/favorites_page.dart';
import 'package:getx_favorites_advanced/feature_puppy/search/views/search_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PuppiesAppBar(),
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Get.find<NavbarController>().selectedPage.type ==
                    NavigationItemType.search
                ? SearchPage()
                : FavoritesPage(),
          ),
        ),
        bottomNavigationBar: _buildNavigationBar(),
      );
}

Widget _buildNavigationBar() {
  final navController = Get.find<NavbarController>();
  return CurvedNavigationBar(
    color: Colors.blueAccent,
    backgroundColor: Colors.transparent,
    items: [
      ...navController.items
          .map((item) => Padding(
                padding: const EdgeInsets.all(8),
                child: item.asWidget(),
              ))
          .toList()
    ],
    animationDuration: const Duration(milliseconds: 300),
    onTap: (index) => navController.selectPage(
      index == 0 ? NavigationItemType.search : NavigationItemType.favorites,
    ),
  );
}

extension NavigationItemToWitget on NavigationItem {
  Widget? asWidget() => type == NavigationItemType.favorites
      ? Obx(
          () => Get.find<FavoritePuppiesController>().count <= 0
              ? type.asIcon()!
              : Badge(
                  padding: const EdgeInsets.all(3),
                  badgeContent: Text(
                    Get.find<FavoritePuppiesController>().count.toString(),
                    style: TextStyles.badgeTextStyle,
                  ),
                  badgeColor: Colors.transparent,
                  elevation: 0,
                  child: type.asIcon(),
                ),
        )
      : type.asIcon();
}
