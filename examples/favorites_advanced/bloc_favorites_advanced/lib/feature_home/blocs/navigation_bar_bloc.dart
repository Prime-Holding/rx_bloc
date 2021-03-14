import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:meta/meta.dart';

part 'navigation_bar_event.dart';

part 'navigation_bar_state.dart';

class NavigationBarBloc extends Bloc<NavigationBarEvent, NavigationBarState> {
  static final _initialItems = [
    NavigationItem(type: NavigationItemType.search, isSelected: true),
    NavigationItem(type: NavigationItemType.favorites, isSelected: false),
  ];

  List<NavigationItem> navItems = _initialItems;

  NavigationBarBloc()
      : super(NavigationBarState(
          title: _initialItems.selected.type.asTitle(),
          selectedItem: _initialItems.selected,
          items: _initialItems,
        ));

  @override
  Stream<NavigationBarState> mapEventToState(
    NavigationBarEvent event,
  ) async* {
    navItems = navItems.copyWithSelected(event.itemType);
    yield NavigationBarState(
      title: navItems.selected.type.asTitle(),
      items: navItems,
      selectedItem: navItems.selected,
    );
  }
}

extension _NavigationItemList on List<NavigationItem> {
  List<NavigationItem> copyWithSelected(
          NavigationItemType navigationItemType) =>
      map((item) => item.copyWith(isSelected: item.type == navigationItemType))
          .toList();

  NavigationItem get selected => firstWhere((element) => element.isSelected);
}
