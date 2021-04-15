import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:appbar_textfield/appbar_textfield.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';

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
                    title: Text(viewModel.selectedPage.asTitle()),
                    autofocus: false,
                  )
                : AppBar(
                    title: Text(
                      viewModel.selectedPage.asTitle(),
                    ),
                  ),
      );
}

class _ViewModel {
  _ViewModel({required this.selectedPage});

  factory _ViewModel.from(Store<AppState> store) =>
      _ViewModel(selectedPage: store.state.navigationState.selectedPage);

  final NavigationItemType selectedPage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          selectedPage == other.selectedPage;

  @override
  int get hashCode => selectedPage.hashCode;
}
