import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_extra_details_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_list_controller.dart';
import 'package:favorites_advanced_base/ui_components.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PuppyListController>();
    return Obx(() => controller.isLoading.value
        ? LoadingWidget()
        : controller.hasError.value
            ? const ErrorRetryWidget(
                onReloadTap: _onReload,
              )
            : Obx(
                () => ListView.builder(
                  key: const Key('LoadingWidget'),
                  itemCount:
                      controller.searchedPuppies.length,
                  itemBuilder: (context, index) => Obx(
                    () {
                      final item = controller
                          .searchedPuppies[index];
                      return PuppyCard(
                        puppy: item,
                        onVisible: (item) =>
                            Get.find<PuppyExtraDetailsController>()
                                .fetchExtraDetails(item),
                        onCardPressed: (item) {},
                        onFavorite: (item, isFavorite) {},
                      );
                    },
                  ),
                ),
              ),
    );
  }
}

void _onReload() {
  Get.find<PuppyListController>().clearError();
}
