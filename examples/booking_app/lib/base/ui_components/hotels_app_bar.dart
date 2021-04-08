import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import '../../feature_home/blocs/navigation_bar_bloc.dart';

class HotelsAppBar extends StatelessWidget implements PreferredSizeWidget {
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
                snapshot.hasData ? snapshot.data!.type.asHotelTitle() : '',
              ),
              centerTitle: false,
            );

  AppBar _searchAppBar(
    BuildContext context,
    NavigationItem item,
  ) =>
      AppBar(
        // searchContainerColor: Colors.blue,
        title: Text(item.type.asHotelTitle()),
        centerTitle: false,

        // style: const TextStyle(color: Colors.white),
        // autofocus: false,
        // decoration: const InputDecoration(
        //   hintText: 'Search ...',
        //   hintStyle: TextStyle(color: Colors.white),
        //   fillColor: Colors.white,
        //   focusColor: Colors.white,
        //   hoverColor: Colors.white,
        // ),
        // clearBtnIcon: const Icon(Icons.close, color: Colors.white),
        // backBtnIcon: const Icon(Icons.arrow_back, color: Colors.white),
        // cursorColor: Colors.white,
        // onBackPressed: () => RxBlocProvider.of<HotelListBlocType>(context)
        //     .events
        //     .filter(query: ''),
        // onClearPressed: () => RxBlocProvider.of<HotelListBlocType>(context)
        //     .events
        //     .filter(query: ''),
        // onChanged: (query) => RxBlocProvider.of<HotelListBlocType>(context)
        //     .events
        //     .filter(query: query),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

extension NavigationItemTypeTitle on NavigationItemType {
  /// Get a representable string based on [NavigationItemType]
  String asHotelTitle() {
    switch (this) {
      case NavigationItemType.search:
        return 'Book a hotel';
      case NavigationItemType.favorites:
        return 'Favorite hotels';
    }
  }
}
