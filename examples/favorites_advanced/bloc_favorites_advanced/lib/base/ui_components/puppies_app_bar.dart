import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:flutter/material.dart';
import 'package:bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PuppiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FocusNode _searchFocus = FocusNode();
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
        // title: Text(item.type.asTitle()),
        title: _buildTitle(context),
        style: const TextStyle(color: Colors.white),
        autofocus: false,
        focusNode: _searchFocus,
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
          FocusScope.of(context).unfocus();
          return BlocProvider.of<PuppyListBloc>(context)
              .add(PuppyListFilterEvent(query: ''));
        },
        onClearPressed: () {
          FocusScope.of(context).unfocus();
          return BlocProvider.of<PuppyListBloc>(context)
              .add(PuppyListFilterEvent(query: ''));
        },
        onChanged: (query) => BlocProvider.of<PuppyListBloc>(context)
            .add(PuppyListFilterEvent(query: query)),
      );

  Widget _buildTitle(BuildContext context) {
    final lastQuery = context.read<PuppyListBloc>().lastSearchedQuery;
    return lastQuery.isNotEmpty
        ? Row(
      children: [
        const SizedBox(width: 30,),
        Text('$lastQuery...'),
      ],
    )
        : const Text('Search for Puppies');
  }
  @override
  Size get preferredSize => const Size.fromHeight(56);
}
