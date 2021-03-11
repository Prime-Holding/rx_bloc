import 'package:flutter/foundation.dart';

import 'package:favorites_advanced_base/models.dart';

class NavigationState {
  final NavigationItemType item;

  // final _items = [
  //   const NavigationItem(type: NavigationItemType.search, isSelected: true),
  //   const NavigationItem(type: NavigationItemType.favorites, isSelected: false),
  // ];

  const NavigationState({
    @required this.item,
  });

  NavigationState.initialState() : item = NavigationItemType.search;
}
