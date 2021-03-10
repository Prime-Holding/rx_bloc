import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:getx_favorites_advanced/base/ui_components/puppies_app_bar.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/controllers/favorite_puppies_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/favorites/views/favorites_page.dart';
import 'package:getx_favorites_advanced/feature_puppy/search/search_page.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavbarController navController = Get.put(NavbarController());
    final FavoritePuppiesController favController =
        Get.put(FavoritePuppiesController());
    return Scaffold(
      appBar: PuppiesAppBar(),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: GetBuilder<NavbarController>(
          builder: (_) => _.selectedPage.type == NavigationItemType.search
              ? SearchPage()
              : FavoritesPage(),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
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
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) => navController.selectPage(
          index == 0 ? NavigationItemType.search : NavigationItemType.favorites,
        ),
      ),
    );
  }
}

extension NavigationItemToWitget on NavigationItem {
  Widget asWidget() => type == NavigationItemType.favorites
      ? Obx(
          () => Get.find<FavoritePuppiesController>().count <= 0
              ? type.asIcon()
              : Badge(
                  padding: const EdgeInsets.all(3),
                  badgeContent: Text(
                    Get.find<FavoritePuppiesController>().count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  badgeColor: Colors.transparent,
                  elevation: 0,
                  child: type.asIcon(),
                ),
        )
      : type.asIcon();
}
