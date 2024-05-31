import 'package:flutter/material.dart';

import '../../models.dart';

extension NavigationItemUtils on NavigationItem {
  NavigationItem copyWith({bool? isSelected, int? count}) => NavigationItem(
        type: type,
        isSelected: isSelected ?? this.isSelected,
      );
}

extension NavigationItemListUtils on List<NavigationItem> {
  /// Get the currently selected index based on [NavigationItem.isSelected]
  int toCurrentIndex() =>
      firstWhere((item) => item.isSelected).type == NavigationItemType.search
          ? 0
          : 1;
}

extension NavigationItemTypeTitle on NavigationItemType {
  /// Get a representable string based on [NavigationItemType]
  String asTitle() {
    switch (this) {
      case NavigationItemType.search:
        return 'Search for Puppies';
      case NavigationItemType.favorites:
        return 'Favorites Puppies';
    }
  }

  /// Get the index based on [NavigationItemType]
  int asIndex() {
    switch (this) {
      case NavigationItemType.search:
        return 0;
      case NavigationItemType.favorites:
        return 1;
    }
  }

  /// Get a subtitle based on [NavigationItemType]
  String asSubtitle() {
    switch (this) {
      case NavigationItemType.search:
        return 'Puppies';
      case NavigationItemType.favorites:
        return 'Favorites';
    }
  }

  /// Convert [NavigationItemType] to an icon based on its type.
  Icon? asIcon() {
    switch (this) {
      case NavigationItemType.search:
        return const Icon(
          Icons.search,
          size: 30,
          color: Colors.white,
        );
      case NavigationItemType.favorites:
        return const Icon(
          Icons.favorite,
          size: 30,
          color: Colors.white,
        );
    }
  }
}
