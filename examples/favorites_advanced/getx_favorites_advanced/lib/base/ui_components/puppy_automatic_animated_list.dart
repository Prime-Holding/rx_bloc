import 'package:automatic_animated_list/automatic_animated_list.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

class PuppyAutomaticAnimatedListView extends StatelessWidget {
  const PuppyAutomaticAnimatedListView({
    required List<Puppy> puppyList,
    Key? key,
  })  : _puppyList = puppyList,
        super(key: key);

  final List<Puppy> _puppyList;

  @override
  Widget build(BuildContext context) => AutomaticAnimatedList<Puppy>(
      items: _puppyList,
      itemBuilder: (context, puppy, animation) => _createTile(
            item: PuppyCard(
              key: Key('${Keys.puppyCardNamePrefix}${puppy.id}'),
              puppy: puppy,
              onFavorite: (puppy, isFavorite) =>
                  Get.find<PuppyManageController>()
                      .markAsFavorite(puppy: puppy, isFavorite: isFavorite),
              onCardPressed: (puppy) {},
              onVisible: (puppy) => Get.find<PuppyExtraDetailsController>()
                  .fetchExtraDetails(puppy),
            ),
            animation: animation,
          ),
      keyingFunction: (puppy) => Key('${Keys.puppyCardNamePrefix}${puppy.id}'));

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
