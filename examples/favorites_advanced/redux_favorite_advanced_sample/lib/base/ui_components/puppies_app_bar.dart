import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:appbar_textfield/appbar_textfield.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';

import '../../feature_home/models/navigation_state.dart';

class PuppiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) => StoreBuilder<NavigationState>(
        builder: (BuildContext context, Store<NavigationState> store) =>
            store.state.selectedPage == NavigationItemType.search
                ? AppBarTextField(
                    title: Text(store.state.selectedPage.asTitle()),
                    autofocus: false,
                  )
                : AppBar(
                    title: Text(
                      store.state.selectedPage.asTitle(),
                    ),
                  ),
      );
}
