import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../feature_home/blocs/navigation_bar_bloc.dart';
import '../../feature_puppy/search/blocs/puppy_list_bloc.dart';

class PuppiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PuppiesAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<NavigationBarBlocType, NavigationItem?>(
        state: (bloc) => bloc.states.selectedItem,
        builder: (ctx, snapshot, bloc) => _buildAppBar(snapshot, ctx),
      );

  Widget _buildAppBar(
          AsyncSnapshot<NavigationItem?> snapshot, BuildContext ctx) =>
      snapshot.hasData && snapshot.data!.type == NavigationItemType.search
          ? _searchAppBar(ctx, snapshot.data!)
          : AppBar(
              title: Text(
                snapshot.hasData ? snapshot.data!.type.asTitle() : '',
              ),
              centerTitle: false,
            );

  AppBarTextField _searchAppBar(
    BuildContext context,
    NavigationItem item,
  ) =>
      AppBarTextField(
        searchContainerColor: Colors.blue,
        title: Text(item.type.asTitle()),
        style: const TextStyle(color: Colors.white),
        autofocus: false,
        decoration: const InputDecoration(
          hintText: 'Search ...',
          hintStyle: TextStyle(color: Colors.white),
          fillColor: Colors.white,
          focusColor: Colors.white,
          hoverColor: Colors.white,
        ),
        clearBtnIcon: const Icon(Icons.close, color: Colors.white),
        backBtnIcon: const Icon(Icons.arrow_back, color: Colors.white),
        cursorColor: Colors.white,
        onBackPressed: () => RxBlocProvider.of<PuppyListBlocType>(context)
            .events
            .filter(query: ''),
        onClearPressed: () => RxBlocProvider.of<PuppyListBlocType>(context)
            .events
            .filter(query: ''),
        onChanged: (query) => RxBlocProvider.of<PuppyListBlocType>(context)
            .events
            .filter(query: query),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
