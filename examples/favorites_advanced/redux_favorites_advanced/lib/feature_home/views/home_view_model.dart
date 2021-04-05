import 'package:favorites_advanced_base/models.dart';
import 'package:redux/redux.dart';
import 'package:equatable/equatable.dart';

import '../../base/models/app_state.dart';

import '../redux/actions.dart';

class HomeViewModel extends Equatable {
  const HomeViewModel({
    required this.items,
    required this.onTapNavBar,
    required this.error,
  });

  factory HomeViewModel.from(Store<AppState> store) {
    void _onTapNavBar(int index) {
      store.dispatch(
        index == 0 ? SearchViewAction() : FavoritesViewAction(),
      );
    }

    return HomeViewModel(
      items: store.state.navigationState.items,
      onTapNavBar: _onTapNavBar,
      error: store.state.error,
    );
  }

  final List<NavigationItem> items;
  final Function(int) onTapNavBar;
  final String error;

  @override
  List<Object> get props => [items, onTapNavBar, error];
}
