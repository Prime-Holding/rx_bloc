import 'package:flutter/foundation.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class NavigationState {
  final List<NavigationItem> items;

  const NavigationState({
    @required this.items,
  });

  NavigationItemType get selectedPage =>
      items.firstWhere((item) => item.isSelected).type;

  NavigationState.initialState()
      : items = [
          const NavigationItem(
              type: NavigationItemType.search, isSelected: true),
          const NavigationItem(
              type: NavigationItemType.favorites, isSelected: false),
        ];
}
