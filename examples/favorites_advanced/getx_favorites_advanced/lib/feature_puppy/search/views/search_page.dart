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
    return Obx(
      () => listController.isLoading.value!
          ? LoadingWidget(
              //will change this key
              key: const ValueKey('LoadingWidget'),
            )
          : listController.hasError.value!
              ? const ErrorRetryWidget(
                  onReloadTap: _onReload,
                )
              : Obx(
                  () {
                    final manageController = Get.find<PuppyManageController>();
                    return ListView.builder(
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
                            onFavorite: (item, isFavorite) =>
                                manageController.favoritePuppy(
                                    puppy: item, isFavorite: isFavorite),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

void _onReload() {
  Get.find<PuppyListController>().clearError();
}
