import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';


class PuppyAnimatedListView extends StatelessWidget {
  PuppyAnimatedListView({
    required List<Puppy> puppyList,
    Function(Puppy)? onPuppyPressed,
    Function(Puppy, bool)? onFavorite,
    Key? key,
  })
      : _puppyList = puppyList,
        _onPuppyPressed = onPuppyPressed,
  _onFavorite = onFavorite,
        super(key: key) {
    initialLoadingOfTheList();
  }

  final Function(Puppy)? _onPuppyPressed;
  final Function(Puppy, bool)? _onFavorite;
  final List<Puppy> _puppyList;
  final _myListKey = GlobalKey<AnimatedListState>();
  final List<Puppy> _tempList = <Puppy>[];

  // Add a delay before tha adding of all elements
  void initialLoadingOfTheList() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      _puppyList.forEach((element) async {
        _tempList.add(element);
        _myListKey.currentState!.insertItem(_tempList.length - 1);
      });
    });
  }

  void initialLoading() {
    var future = Future(() {});
    for (var i = 0; i < _puppyList.length; i++) {
      // Add a delay before every adding of an element
      future = future.then((_) =>
          Future.delayed(
            const Duration(milliseconds: 300),
                () {
              _tempList.add(_puppyList[i]);
              _myListKey.currentState!.insertItem(_tempList.length - 1);
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) =>
      AnimatedList(
          key: _myListKey,
          padding: const EdgeInsets.only(bottom: 67),
          initialItemCount: _tempList.length,
          itemBuilder: (context, index, animation) =>
          buildItem(context, _tempList[index], index, animation));

  Widget buildItem(BuildContext context, item, int index,
      Animation<double> animation) =>
      _createTile(
          PuppyCard(
            key: Key('${key.toString()}${item.id}'),
            puppy: item,
            onCardPressed: (item) => _onPuppyPressed?.call(item),
            onFavorite: (puppy, isFavorite) {
              removeItem(index);
                _onFavorite?.call(puppy, isFavorite);
            },
          ),
          animation,
          index);

  void removeItem(int index) {
    final item = _tempList.removeAt(index);
    _myListKey.currentState!.removeItem(
      index,
          (context, animation) => buildItem(context, item, index, animation),
    );
  }

  void insertItem(int index) {
    _myListKey.currentState?.insertItem(index);
  }

  Widget _createTile(PuppyCard item, Animation<double> animation, int index) =>
      SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: item,
      );
}