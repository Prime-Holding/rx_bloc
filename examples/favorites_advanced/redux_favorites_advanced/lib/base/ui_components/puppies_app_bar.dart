import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';

import '../../feature_puppy/search/redux/actions.dart';
import '../models/app_state.dart';

class PuppiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.from(store),
        distinct: true,
        builder: (_, viewModel) =>
            viewModel.selectedPage == NavigationItemType.search
                ? AppBarTextField(
                    defaultHintText: viewModel.searchQuery != ''
                        ? viewModel.searchQuery
                        : 'Search...',
                    title: viewModel.searchQuery != ''
                        ? Text(viewModel.searchQuery)
                        : Text(viewModel.selectedPage.asTitle()),
                    autofocus: false,
                    onChanged: (query) => viewModel.onSearch(query),
                    onBackPressed: () {
                      FocusScope.of(context).unfocus();
                      viewModel.onSearch('');
                    },
                    onClearPressed: () => viewModel.onSearch(''),
                  )
                : AppBar(
                    title: Text(
                      viewModel.selectedPage.asTitle(),
                    ),
                  ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel({
    required this.selectedPage,
    required this.searchQuery,
    required this.onSearch,
  });

  factory _ViewModel.from(Store<AppState> store) {
    void _onSearch(String query) {
      if (query != store.state.puppyListState.searchQuery) {
        store.dispatch(SearchAction(query: query));
      }
    }

    return _ViewModel(
      selectedPage: store.state.navigationState.selectedPage,
      searchQuery: store.state.puppyListState.searchQuery,
      onSearch: _onSearch,
    );
  }

  final NavigationItemType selectedPage;
  final String searchQuery;
  final Function onSearch;

  @override
  List<Object> get props => [selectedPage, searchQuery, onSearch];
}
