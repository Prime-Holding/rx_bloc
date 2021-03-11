import 'package:get/get.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';

class NavbarController extends GetxController {
  final _items = [
    const NavigationItem(type: NavigationItemType.search, isSelected: true),
    const NavigationItem(type: NavigationItemType.favorites, isSelected: false),
  ].obs;

  NavigationItem get selectedPage =>
      _items.firstWhere((element) => element.isSelected);

  void selectPage(NavigationItemType selectedItem) => _items.assignAll(_items
      .map((item) => item.copyWith(isSelected: selectedItem == item.type)));

  List<NavigationItem> get items => List.from(_items);

  String get title => selectedPage.type.asTitle();
}
