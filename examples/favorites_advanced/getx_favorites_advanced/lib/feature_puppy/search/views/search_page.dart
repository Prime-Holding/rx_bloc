import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';

import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

class SearchPage extends GetView<PuppyListController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: controller.obx(
          (puppies) => Obx(() => RefreshIndicator(
                onRefresh: () async {
                  await controller.onReload();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 67),
                  itemCount: puppies.length,
                  itemBuilder: (context, index) =>
                      MixinBuilder<PuppyManageController>(
                    builder: (controller) {
                      final Puppy item = puppies[index];
                      return PuppyCard(
                        key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                        puppy: item,
                        onVisible: (item) =>
                            Get.find<PuppyExtraDetailsController>()
                                .fetchExtraDetails(item),
                        onCardPressed: (item) {},
                        onFavorite: (item, isFavorite) {
                          controller.markAsFavorite(
                              puppy: item, isFavorite: isFavorite);
                          if (controller.errorMessages.isNotEmpty) {
                            Get.snackbar(
                              'title',
                              controller.errorMessages.first,
                              snackPosition: SnackPosition.BOTTOM,
                              animationDuration: const Duration(seconds: 2),
                            );
                            controller.clearError();
                          }
              // if (Get.find<NetworkController>().connectivityStatus==0) {
              //   print('status Error is true');
              //   Get.snackbar(
              //       '', manageController.status.errorMessage.toString(),
              //       snackPosition: SnackPosition.BOTTOM,
           //       animationDuration: const Duration(seconds: 2),
                          //       backgroundColor: Colors.black54,
                          //       colorText: ColorStyles.white);
                          //   manageController.clearError();
                          // }
                        },
                      );
                    },
                        initState: (state){
                          final manageController =
                          Get.find<PuppyManageController>();
                          print('Let check if condition');
                          if (manageController.errorMessages.isNotEmpty) {
                            print('Pass if conditions');
                            Get.snackbar(
                              'title',
                              manageController.errorMessages.first,
                              snackPosition: SnackPosition.BOTTOM,
                              animationDuration: const Duration(seconds: 2),
                            );
                            manageController.clearError();
                          }
                        },
                    didChangeDependencies: (state) {
                    },
                  ),
                ),
              )),
          onError: (error) => ErrorRetryWidget(
            onReloadTap: () {
              controller.onReload();
            },
          ),
        ),
      );
}
