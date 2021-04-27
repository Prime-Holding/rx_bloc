import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:flutter/material.dart';
import 'package:bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PuppiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (ctx, state) => _buildAppBar(ctx, state),
      );

  Widget _buildAppBar(BuildContext context, NavigationBarState state) =>
      state.selectedItem.type == NavigationItemType.search
          ? _searchAppBar(context, state.selectedItem)
          : AppBar(
              title: Text(
                state.selectedItem.type.asTitle(),
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
        onBackPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          return BlocProvider.of<PuppyListBloc>(context)
              .add(PuppyListFilterEvent(query: ''));
        },
        onClearPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          return BlocProvider.of<PuppyListBloc>(context)
              .add(PuppyListFilterEvent(query: ''));
        },
        onChanged: (query) => BlocProvider.of<PuppyListBloc>(context)
            .add(PuppyListFilterEvent(query: query)),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
