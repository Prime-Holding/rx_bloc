import 'dart:async';

import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'navigation_bar_bloc.rxb.g.dart';
part 'navigation_bar_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class NavigationBarEvents {
  void selectPage(NavigationItemType item);
}

abstract class NavigationBarStates {
  @RxBlocIgnoreState()
  Stream<List<NavigationItem>> get items;

  @RxBlocIgnoreState()
  Stream<NavigationItem> get selectedItem;

  Stream<String> get title;
}

@RxBloc()
class NavigationBarBloc extends $NavigationBarBloc {
  NavigationBarBloc() {
    _$selectPageEvent.updateItems(_items).addTo(_compositeSubscription);
  }

  final _items = BehaviorSubject<List<NavigationItem>>.seeded([
    const NavigationItem(type: NavigationItemType.search, isSelected: true),
    const NavigationItem(type: NavigationItemType.favorites, isSelected: false),
  ]);

  @override
  Stream<List<NavigationItem>> get items => _items;

  @override
  Stream<String> _mapToTitleState() => _items.mapToSelectedTitle();

  @override
  Stream<NavigationItem> get selectedItem => _items.selected;

  @override
  void dispose() {
    _items.close();
    super.dispose();
  }
}
