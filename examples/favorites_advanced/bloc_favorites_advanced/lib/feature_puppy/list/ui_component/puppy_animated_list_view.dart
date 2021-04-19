// import 'package:bloc_sample/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

// import '../../blocs/puppies_extra_details_bloc.dart';
// import '../../blocs/puppy_manage_bloc.dart';

class PuppyAnimatedListView extends StatelessWidget {
  PuppyAnimatedListView({
    required List<Puppy> puppyList,
    Function(Puppy)? onPuppyPressed,
    Key? key,
  })
      : _puppyList = puppyList,
        _onPuppyPressed = onPuppyPressed,
        super(key: key){
    // print('Constructor');
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   _myListKey.currentState?.insertItem(_puppyList.length - 1);
    //
    // });
  }


  final Function(Puppy)? _onPuppyPressed;
  final List<Puppy> _puppyList;
  final _myListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    // _myListKey.currentState?.insertItem(_puppyList.length - 1);
    // print('build');
    return AnimatedList(
        key: _myListKey,
        padding: const EdgeInsets.only(bottom: 67),
        initialItemCount: _puppyList.length,

        itemBuilder: (context, index, animation) {
          // _myListKey.currentState?.insertItem(index);
          final item = _puppyList[index];
          // itemBuilder: (item, index, context, animation) => _createTile(
          // print('Item builder');
          return _createTile(
            PuppyCard(
              key: Key('${key.toString()}${item.id}'),
              puppy: item,
              onCardPressed: (item) => _onPuppyPressed?.call(item),
              onFavorite: (puppy, isFavorite) {
                // _myListKey.currentState!
                //     .removeItem(index, (context, animation) =>
                //     _createRemovedTile(, animation));
                return context
                    .read<FavoritePuppiesBloc>()
                    .add(FavoritePuppiesMarkAsFavoriteEvent(
                    puppy: puppy, isFavorite: isFavorite));
              },
            ),
            animation,
            // context,
            // index
          );
        },

        //   itemRemovedBuilder: (item, index, context, animation) =>
        //     _createRemovedTile(
        //   PuppyCard(
        //     key: Key('${key.toString()}${item.id}'),
        //     puppy: item,
        //     onFavorite: (_, isFavorite) {},
        //     onCardPressed: (puppy) {},
        //       onVisible: (puppy) => context
        //           .read<PuppiesExtraDetailsBloc>()
        //           .add(FetchPuppyExtraDetailsEvent(puppy))
        //   ),
        //   animation,
        // ),
        // streamList: _puppyList,
        // primary: true,
        // padding: const EdgeInsets.only(bottom: 67),
        // itemBuilder: (item, index, context, animation) => _createTile(
        //   PuppyCard(
        //     key: Key('${key.toString()}${item.id}'),
        //     puppy: item,
        //     onCardPressed: (item) => _onPuppyPressed?.call(item),
        //     onFavorite: (puppy, isFavorite) => context
        //       .read<FavoritePuppiesBloc>()
        //       .add(FavoritePuppiesMarkAsFavoriteEvent(
        //     puppy: puppy, isFavorite: isFavorite)),
        //   ),
        //   animation,
        // ),
        // itemRemovedBuilder: (item, index, context, animation) =>
        //     _createRemovedTile(
        //   PuppyCard(
        //     key: Key('${key.toString()}${item.id}'),
        //     puppy: item,
        //     onFavorite: (_, isFavorite) {},
        //     onCardPressed: (puppy) {},
        //       onVisible: (puppy) => context
        //           .read<PuppiesExtraDetailsBloc>()
        //           .add(FetchPuppyExtraDetailsEvent(puppy))
        //   ),
        //   animation,
        // ),
      );
}

  // Tween<Offset> _offset = Tween(begin: Offset(1,0), end: Offset(0,0));
  Widget _createTile(PuppyCard item, Animation<double> animation) {
    // print('Above SizeTransition ');
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: item,
    );
  }

  Widget _createRemovedTile(PuppyCard item, Animation<double> animation) =>
      SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: item,
      );
}
