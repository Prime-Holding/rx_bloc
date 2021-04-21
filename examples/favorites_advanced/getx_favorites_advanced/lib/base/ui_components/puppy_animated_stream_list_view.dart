import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

class PuppyAnimatedStreamListView extends StatelessWidget {
  const PuppyAnimatedStreamListView({
    required Stream<List<Puppy>> puppyList,
    Function(Puppy)? onPuppyPressed,
    Key? key,
  })  : _puppyList = puppyList,
        _onPuppyPressed = onPuppyPressed,
        super(key: key);

  final Function(Puppy)? _onPuppyPressed;
  final Stream<List<Puppy>> _puppyList;

  @override
  Widget build(BuildContext context) {
    print('///////////////////////////////////////////////////////////////');
    _puppyList.listen((event) {
      print('In AnimatedList have ${event.runtimeType} ');
      print('with ${event.length} elements');
      event.forEach((element) {
        print('${element.toString()}');
      });
    });
    return AnimatedStreamList<Puppy>(
      streamList: _puppyList,
      primary: true,
      padding: const EdgeInsets.only(bottom: 67),
      itemBuilder: (item, index, context, animation) => _createTile(
        PuppyCard(
          key: Key('${key.toString()}${item.id}'),
          puppy: item,
          onCardPressed: (item) => _onPuppyPressed?.call(item),
          onFavorite: (puppy, isFavorite) => Get.find<PuppyManageController>()
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
          onVisible: (puppy) =>
              Get.find<PuppyExtraDetailsController>().fetchExtraDetails(puppy),
        ),
        animation,
      ),
    );
  }

  Widget _createTile(Widget item, Animation<double> animation) =>
      SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GetX(builder: (_) => item),
      );

  Widget _createRemovedTile(Widget item, Animation<double> animation) =>
      SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GetX(builder: (_) => item),
      );
}
