import 'package:get/get.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';

class NavbarController extends GetxController {
  final _items = [
    const NavigationItem(type: NavigationItemType.search, isSelected: true),
    const NavigationItem(type: NavigationItemType.favorites, isSelected: false),
  ].obs;

  void selectPage(NavigationItemType selectedItem) => _items.setAll(
      0,
      _items
          .map((item) => item.copyWith(isSelected: selectedItem == item.type)));

  NavigationItem get selectedPage =>
      _items.firstWhere((element) => element.isSelected);

  List<NavigationItem> get items => [..._items];

  String get title => selectedPage.type.asTitle();
}
