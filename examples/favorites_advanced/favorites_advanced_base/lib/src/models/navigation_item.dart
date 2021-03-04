import 'package:flutter/foundation.dart';

enum NavigationItemType { search, favorites }

class NavigationItem {
  const NavigationItem({
    required this.type,
    required this.isSelected,
  });

  final NavigationItemType type;
  final bool isSelected;

  @override
  bool operator ==(dynamic other) {
    if (other is NavigationItem) {
      return type == other.type && isSelected == other.isSelected;
    }

    return false;
  }

  @override
  int get hashCode => super.hashCode;
}
