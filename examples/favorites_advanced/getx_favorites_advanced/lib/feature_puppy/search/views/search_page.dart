import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_navigation/get_navigation.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';

import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

class SearchPage extends GetView<PuppyListController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: controller.obx(
          (puppies) {
            final manageController = Get.find<PuppyManageController>();
            return RefreshIndicator(
              onRefresh: () async {
                await controller.onReload();
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 67),
                itemCount: puppies.length,
                itemBuilder: (context, index) => Obx(
                  () {
                    final Puppy item = puppies[index];
                    return PuppyCard(
                      key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                      puppy: item,
                      onVisible: (item) =>
                          Get.find<PuppyExtraDetailsController>()
                              .fetchExtraDetails(item),
                      onCardPressed: (item) {},
                      onFavorite: (item, isFavorite) {
                        manageController.markAsFavorite(
                            puppy: item, isFavorite: isFavorite);
                        // if (manageController.status.isError) {
                        //   print('status Error is true');
                        //   Get.snackbar(
                        //       '', manageController.status.errorMessage!,
                        //       snackPosition: SnackPosition.BOTTOM,
                        //       animationDuration: const Duration(seconds: 2),
                        //       backgroundColor: Colors.black54,
                        //       colorText: ColorStyles.white);
                        //   manageController.clearError();
                        // }
                      },
                    );
                  },
                ),
              ),
            );
          },
          onError: (error) => ErrorRetryWidget(
            onReloadTap: () {
              controller.onReload();
            },
          ),
        ),
      );
}
