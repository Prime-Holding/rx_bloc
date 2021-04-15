import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

class PuppyAnimatedListView extends StatelessWidget {
  PuppyAnimatedListView({
    required List<Puppy> puppyList,
    Function(Puppy)? onPuppyPressed,
    Key? key,
  })  : _puppyList = puppyList,
        _onPuppyPressed = onPuppyPressed,
        super(key: key);

  final Function(Puppy)? _onPuppyPressed;
  final List<Puppy> _puppyList;
  final listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) => AnimatedList(
        key: listKey,
        initialItemCount: _puppyList.length,
        primary: true,
        padding: const EdgeInsets.only(bottom: 67),
        itemBuilder: (context, index, animation) => _createTile(
          PuppyCard(
              key: Key('${key.toString()}${_puppyList[index].id}'),
              puppy: _puppyList[index],
              onCardPressed: (item) => _onPuppyPressed?.call(item),
              onFavorite: (puppy, isFavorite) {
                AnimatedList.of(context).removeItem(
                  index,
                  (context, animation) => _createRemovedTile(
                    PuppyCard(
                      key: Key('${key.toString()}${_puppyList[index].id}'),
                      puppy: _puppyList[index],
                      onFavorite: (_, isFavorite) {},
                      onCardPressed: (puppy) {},
                      onVisible: (puppy) =>
                          Get.find<PuppyExtraDetailsController>()
                              .fetchExtraDetails(puppy),
                    ),
                    animation,
                  ),
                );
                Get.find<PuppyManageController>()
                    .markAsFavorite(puppy: puppy, isFavorite: isFavorite);
              }),
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
