import 'dart:io';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/details/controllers/puppy_details_controller.dart';

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<PuppyDetailsController>();
    // final puppy = controller.puppy!=null ? controller.puppy!.value : _puppy;
    final puppy = controller.puppy!.value;
    final name = puppy.displayName;
    final gender = puppy.gender;
    final bread = puppy.breedTypeAsString;
    final characteristics = puppy.breedCharacteristics;
    // final isFavorite = controller.isFavorite.value;
    final imagePath = puppy.asset;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   bottomOpacity: 0,
      //   backgroundColor: Colors.transparent,
      //   actions: [
      //     _buildFavoriteIcon(puppy, isFavorite),
      //     IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
      //   ],
      // ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imagePath.contains('asset')
                      ? AssetImage(imagePath)
                      : FileImage(File(imagePath)) as ImageProvider<Object>,
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'MyName',
                  style: TextStyles.titleTextStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '$gender, $bread',
                  style: TextStyles.subtitleTextStyle,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  characteristics,
                  style: TextStyles.subtitleTextStyle,
                )
              ],
            ),
          ),
          _buildAppBar(),
          // _buildAppBar(puppy, isFavorite),
        ],
      ),
    );
  }

  Widget _buildFavoriteIcon(Puppy puppy, bool isFavorite) {
    var favoriteStatus  = isFavorite;
    return
      favoriteStatus
          ? IconButton(
        icon: const Icon(Icons.favorite),
        onPressed: () {
          Get.find<PuppyManageController>()
              .markAsFavorite(puppy: puppy, isFavorite: false);
          favoriteStatus = false;
        },
      )
          : IconButton(
        icon: const Icon(Icons.favorite_border),
        onPressed: () {
          Get.find<PuppyManageController>()
              .markAsFavorite(puppy: puppy, isFavorite: true);
          favoriteStatus = true;
        }
    );

  }

  Widget _buildAppBar()=> Obx(
        () {
          final detailsController = Get.find<PuppyDetailsController>();
          final puppy = detailsController.puppy!.value;
          final isFavorite = detailsController.isFavorite.value;
          return AppBar(
          bottomOpacity: 0,
          backgroundColor: Colors.transparent,
          actions: [
            _buildFavoriteIcon(puppy, isFavorite),
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          ],
        );
        }
    );

  // Widget _buildAppBar(Puppy puppy, bool isFavorite)=>  AppBar(
  //         bottomOpacity: 0,
  //         backgroundColor: Colors.transparent,
  //         actions: [
  //           _buildFavoriteIcon(puppy, isFavorite),
  //           IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
  //         ],
  //       );
}
