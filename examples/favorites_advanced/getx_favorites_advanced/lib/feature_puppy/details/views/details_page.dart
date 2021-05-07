import 'dart:io';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/base/routes/app_pages.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/details/controllers/puppy_details_controller.dart';

class DetailsPage extends StatelessWidget {
  final controller = Get.find<PuppyDetailsController>();

  @override
  Widget build(BuildContext context) {
    final puppy = controller.puppy!.value;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Hero(
            tag: '$PuppyCardAnimationTag ${puppy.id}',
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: puppy.asset.contains('asset')
                        ? AssetImage(puppy.asset)
                        : FileImage(File(puppy.asset)) as ImageProvider<Object>,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.puppy!.value.displayName ?? 'MyName',
                    style: TextStyles.titleTextStyle,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(
                  () => Text(
                    '${controller.puppy!.value.genderAsString}, '
                        '${controller.puppy!.value.breedTypeAsString}',
                    style: TextStyles.subtitleTextStyle,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Obx(
                  () => Text(
                    controller.puppy!.value.displayCharacteristics!,
                    style: TextStyles.subtitleTextStyle,
                  ),
                ),
              ],
            ),
          ),
          _buildAppBar(),
          // _buildAppBar(puppy, isFavorite),
        ],
      ),
    );
  }

  Widget _buildFavoriteIcon(Puppy puppy, bool isFavorite) => puppy.isFavorite
      ? IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => Get.find<PuppyManageController>()
              .markAsFavorite(puppy: puppy, isFavorite: false))
      : IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => Get.find<PuppyManageController>()
              .markAsFavorite(puppy: puppy, isFavorite: true));

  Widget _buildAppBar() => Obx(() {
        final detailsController = Get.find<PuppyDetailsController>();
        final puppy = detailsController.puppy!.value;
        final isFavorite = puppy.isFavorite;
        return AppBar(
          bottomOpacity: 0,
          backgroundColor: Colors.transparent,
          actions: [
            _buildFavoriteIcon(puppy, isFavorite),
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Get.toNamed(AppPages.edit, arguments: puppy);
                }),
          ],
        );
      });
}
