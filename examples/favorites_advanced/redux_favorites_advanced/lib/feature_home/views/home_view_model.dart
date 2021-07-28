import 'package:favorites_advanced_base/models.dart';
import 'package:redux/redux.dart';
import 'package:equatable/equatable.dart';

import '../../base/models/app_state.dart';

import '../redux/actions.dart';

class HomeViewModel extends Equatable {
  const HomeViewModel({
    required this.items,
    required this.favCount,
    required this.error,
    required this.onTapNavBar,
  });

  factory HomeViewModel.from(Store<AppState> store) {
    void _onTapNavBar(int index) {
      store.dispatch(
        index == 0 ? SearchViewAction() : FavoritesViewAction(),
      );
    }

    return HomeViewModel(
      items: store.state.navigationState.items,
      favCount: store.state.favoriteCount,
      error: store.state.error,
      onTapNavBar: _onTapNavBar,
    );
  }

  final List<NavigationItem> items;
  final int favCount;
  final String error;
  final Function(int) onTapNavBar;

  @override
  List<Object> get props => [items, favCount, error, onTapNavBar];
}
