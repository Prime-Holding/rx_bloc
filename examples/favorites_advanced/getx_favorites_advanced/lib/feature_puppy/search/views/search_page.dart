import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listController = Get.find<PuppyListController>();
    final manageController = Get.find<PuppyManageController>();
    return Obx(
      () => listController.isLoading.value!
          ? LoadingWidget()
          : listController.hasError.value!
              ? ErrorRetryWidget(
                  onReloadTap: () => listController.onReload(),
                )
              : Obx(
                  () => RefreshIndicator(
                    onRefresh: () => listController.updatePuppies(),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 67),
                      itemCount: listController.searchedPuppies.length,
                      itemBuilder: (context, index) => Obx(
                        () {
                          final item = listController.searchedPuppies[index];
                          return PuppyCard(
                            key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                            puppy: item,
                            onVisible: (item) =>
                                Get.find<PuppyExtraDetailsController>()
                                    .fetchExtraDetails(item),
                            onCardPressed: (item) {},
                            onFavorite: (item, isFavorite) {
                              manageController.favoritePuppy(
                                  puppy: item, isFavorite: isFavorite);
                              if (manageController.onError.isNotEmpty) {
                                Get.snackbar(
                                    '',
                                    manageController.onError.first
                                        .substring(10),
                                    snackPosition: SnackPosition.BOTTOM,
                                    animationDuration:
                                        const Duration(seconds: 2),
                                    backgroundColor: Colors.black54,
                                colorText: ColorStyles.white);
                                manageController.clearError();
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
    );
  }
}
