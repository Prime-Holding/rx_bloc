import 'package:animated_stream_list_nullsafety/animated_stream_list.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../blocs/puppies_extra_details_bloc.dart';
import '../../blocs/puppy_manage_bloc.dart';

class PuppyAnimatedListView extends StatelessWidget {
  const PuppyAnimatedListView({
    required Stream<List<Puppy>> puppyList,
    Function(Puppy)? onPuppyPressed,
    super.key,
  })  : _puppyList = puppyList,
        _onPuppyPressed = onPuppyPressed;

  final Function(Puppy)? _onPuppyPressed;
  final Stream<List<Puppy>> _puppyList;

  @override
  Widget build(BuildContext context) => AnimatedStreamList<Puppy>(
        streamList: _puppyList,
        primary: true,
        padding: const EdgeInsets.only(bottom: 67),
        itemBuilder: (item, index, context, animation) => _createTile(
          PuppyCard(
            key: Key('${key.toString()}${item.id}'),
            puppy: item,
            onCardPressed: (item) => _onPuppyPressed?.call(item),
            onFavorite: (puppy, isFavorite) =>
                RxBlocProvider.of<PuppyManageBlocType>(context)
                    .events
                    .markAsFavorite(puppy: puppy, isFavorite: isFavorite),
          ),
          animation,
        ),
        itemRemovedBuilder: (item, index, context, animation) =>
            _createRemovedTile(
          PuppyCard(
            key: Key('${key.toString()}${item.id}'),
            puppy: item,
            onFavorite: (_, isFavorite) {},
            onCardPressed: (puppy) {},
            onVisible: (puppy) => context
                .read<PuppiesExtraDetailsBlocType>()
                .events
                .fetchExtraDetails(puppy),
          ),
          animation,
        ),
      );

  Widget _createTile(PuppyCard item, Animation<double> animation) =>
      SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: item,
      );

  Widget _createRemovedTile(PuppyCard item, Animation<double> animation) =>
      SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: item,
      );
}
