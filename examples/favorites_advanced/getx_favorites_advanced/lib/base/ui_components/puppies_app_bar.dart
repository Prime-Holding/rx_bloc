import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appbar_textfield/appbar_textfield.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:getx_favorites_advanced/feature_home/controllers/navbar_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/search/controllers/puppy_list_controller.dart';

class PuppiesAppBar extends StatelessWidget implements PreferredSizeWidget {

  final controller = Get.find<PuppyListController>();

  AppBarTextField _searchAppBar() => AppBarTextField(
        title: _createTitle(),
        style: const TextStyle(color: Colors.white),
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            focusColor: Colors.white,
            hoverColor: Colors.white),
        clearBtnIcon: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
        backBtnIcon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        onBackPressed: () => _clearSearching(unfocus: true),
        onClearPressed: () => _clearSearching(unfocus: false),
        onChanged: (text) => controller.setFilter(text),
      );

  void _clearSearching({required bool unfocus}){
    controller.setFilter('');
    if(unfocus){
      Get.focusScope?.unfocus();
    }
  }

  Widget _createTitle() =>
      controller.filteredBy.value != ''
        ? Row(
          children: [
            const SizedBox(width: 30,),
            Text('${controller.filteredBy}...'),
          ],
        )
        :const Text('Search for Puppies');

  @override
  Widget build(BuildContext context) => Obx(
        () => Get.find<NavbarController>().selectedPage.type ==
                NavigationItemType.search
            ? _searchAppBar()
            : AppBar(
                title: const Text(
                  'Favorites Puppies',
                ),
              ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
