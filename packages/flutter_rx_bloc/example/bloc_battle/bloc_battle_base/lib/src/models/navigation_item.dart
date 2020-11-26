import 'package:flutter/foundation.dart';

enum NavigationItemType { search, favorites }

class NavigationItem {
  const NavigationItem({
    @required this.type,
    @required this.isSelected,
  });

  final NavigationItemType type;
  final bool isSelected;
}
