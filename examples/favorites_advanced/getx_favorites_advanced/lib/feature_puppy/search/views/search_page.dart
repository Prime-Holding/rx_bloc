import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';

import 'package:getx_favorites_advanced/base/controllers/network_controller.dart';
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
              onRefresh: () => controller.updatePuppies(),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 67),
                itemCount: puppies.length,
                itemBuilder: (context, index) => Obx(
                  () {
                    final Puppy item = puppies[index];
                    return Stack(
                      children: [
                        PuppyCard(
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
                              Get.snackbar('',
                                  manageController.onError.first.substring(10),
                                  snackPosition: SnackPosition.BOTTOM,
                                  animationDuration: const Duration(seconds: 2),
                                  backgroundColor: Colors.black54,
                                  colorText: ColorStyles.white);
                              manageController.clearError();
                            }
                          },
                        ),
                        if (Get.find<NetworkController>()
                                    .connectivityStatus
                                    .value ==
                                0 &&
                            !item.hasExtraDetails())
                          _buildCard()
                      ],
                    );
                  },
                ),
              ),
            );
          },
          onError: (_) => ErrorRetryWidget(
            onReloadTap: () {
              controller.onReload();
              Get.find<PuppyExtraDetailsController>().onReload();
            },
          ),
        ),
      );

  Widget _buildCard() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Card(
          elevation: 2,
          child: ListTile(
              // tileColor: Colors.red,
              contentPadding: const EdgeInsets.only(
                left: 12,
                right: 4,
                top: 8,
                bottom: 4,
              ),
              leading: ClipOval(
                  child: Image.asset(
                'assets/image_placeholder.jpeg',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              )),
              title: Container(
                width: double.infinity,
                height: 19,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: const Text('  An error occur',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.left),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 67,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: const Text(
                    '  No internet connection',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              trailing: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.error),
              )),
        ),
      );
}
