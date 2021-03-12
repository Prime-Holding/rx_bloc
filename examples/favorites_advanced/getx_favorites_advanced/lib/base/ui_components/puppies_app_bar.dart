import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';

class PuppiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  AppBarTextField _searchAppBar() {
    return AppBarTextField(
      title: Text('Search for Puppies'),
      style: const TextStyle(color: Colors.white),
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Colors.white),
          fillColor: Colors.white,
          focusColor: Colors.white,
          hoverColor: Colors.white),
      clearBtnIcon: Icon(
        Icons.clear,
        color: Colors.white,
      ),
      backBtnIcon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      onBackPressed: () {},
      onClearPressed: () {},
      onChanged: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    Get.find<NavbarController>().selectedPage.type == NavigationItemType.search
              ? _searchAppBar()
              : AppBar(
                  title: Text(
                    "Favorites Puppies",
                  ),
                ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
