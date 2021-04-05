import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

@immutable
class NavigationState extends Equatable {
  const NavigationState({
    required this.items,
  });

  NavigationState.initialState()
      : items = [
          const NavigationItem(
              type: NavigationItemType.search, isSelected: true),
          const NavigationItem(
              type: NavigationItemType.favorites, isSelected: false),
        ];

  final List<NavigationItem> items;

  NavigationItemType get selectedPage =>
      items.firstWhere((item) => item.isSelected).type;

  @override
  List<Object> get props => [items];
}
