import 'package:declarative_animated_list/declarative_animated_list.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';

class PuppyAnimatedListView extends StatelessWidget {
  const PuppyAnimatedListView({
    required List<Puppy> puppyList,
    Function(Puppy)? onPuppyPressed,
    Function(Puppy, bool)? onFavorite,
    Key? key,
  })  : _puppyList = puppyList,
        _onPuppyPressed = onPuppyPressed,
        _onFavorite = onFavorite,
        super(key: key);

  final Function(Puppy)? _onPuppyPressed;
  final Function(Puppy, bool)? _onFavorite;
  final List<Puppy> _puppyList;

  @override
  Widget build(BuildContext context) => DeclarativeList(
        items: _puppyList,
        itemBuilder: (context, Puppy puppy, index, animation) => _createTile(
          item: PuppyCard(
            key: Key('${Keys.puppyCardNamePrefix}${puppy.id}'),
            puppy: puppy,
            onFavorite: (puppy, isFavorite) =>
                _onFavorite?.call(puppy, isFavorite),
            onCardPressed: (puppy) => _onPuppyPressed?.call(puppy),
            onVisible: (puppy) => {},
          ),
          animation: animation,
        ),
        removeBuilder: (context, Puppy puppy, index, animation) => _createTile(
          item: PuppyCard(
            key: Key('${Keys.puppyCardNamePrefix}${puppy.id}'),
            puppy: puppy,
            onFavorite: (puppy, isFavorite) =>
                _onFavorite?.call(puppy, isFavorite),
            onCardPressed: (puppy) => _onPuppyPressed?.call(puppy),
            onVisible: (puppy) => {},
          ),
          animation: animation,
        ),
      );

  Widget _createTile(
          {required Widget item, required Animation<double> animation}) =>
      FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
          child: item,
        ),
      );
}
