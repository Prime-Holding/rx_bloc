import 'package:bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/src/models/navigation_item.dart';

class Stub {
  static final navigation = NavigationStub();
}

class NavigationStub {
  static final _initialItems = [
    NavigationItem(type: NavigationItemType.search, isSelected: true),
    NavigationItem(type: NavigationItemType.favorites, isSelected: false),
  ];

  static final _favoritesItems = [
    NavigationItem(type: NavigationItemType.search, isSelected: false),
    NavigationItem(type: NavigationItemType.favorites, isSelected: true),
  ];

  final initialSearchState = NavigationBarState(
    title: _initialItems.firstWhere((element) => element.isSelected).type.asTitle(),
    items: _initialItems,
    selectedItem: _initialItems.firstWhere((element) => element.isSelected),
  );

  final favoritesState = NavigationBarState(
    title: _favoritesItems.firstWhere((element) => element.isSelected).type.asTitle(),
    items: _favoritesItems,
    selectedItem: _favoritesItems.firstWhere((element) => element.isSelected),
  );
}
