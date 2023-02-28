import 'dart:async';

import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'navigation_bar_bloc.rxb.g.dart';
part 'navigation_bar_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class NavigationBarBlocEvents {
  void selectPage(NavigationItemType item);
}

abstract class NavigationBarBlocStates {
  @RxBlocIgnoreState()
  Stream<List<NavigationItem>> get items;

  @RxBlocIgnoreState()
  Stream<NavigationItem> get selectedItem;

  Stream<String> get title;
}

@RxBloc()
class NavigationBarBloc extends $NavigationBarBloc {
  NavigationBarBloc(NavigationItemType navigationType)
      : _items = BehaviorSubject<List<NavigationItem>>.seeded(
            NavigationItemType.values
                .map((type) => NavigationItem(
                      type: type,
                      isSelected: type == navigationType,
                    ))
                .toList()) {
    _$selectPageEvent.updateItems(_items).addTo(_compositeSubscription);
  }

  final BehaviorSubject<List<NavigationItem>> _items;

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
