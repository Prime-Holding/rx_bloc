import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/ui_components/puppy_edit_form.dart';

class EditPage extends StatelessWidget {
  final controller = Get.find<PuppyManageController>(tag:'Edit');
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Puppy'),
          actions: [
            _buildSaveIcon(),
          ],
        ),
        body: PuppyEditForm(globalFormKey, controller.editedPuppy),
      );

  Widget _buildSaveIcon() => Obx(
        () => IconButton(
            icon: controller.isLoading.value
                ? Container(
                    height: 24,
                    width: 24,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ))
                : Obx(
                    () => Icon(
                      Icons.save,
                      color: controller.isSaveEnabled()
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
            onPressed: () async {
              controller.enableValidation();
              if (controller.isSaveEnabled() &&
                  globalFormKey.currentState!.validate()) {
                Get.focusScope!.unfocus();
                globalFormKey.currentState!.save();
                final resultMessage = await controller.savePuppy();
                if(resultMessage.contains('success')){
                  Get.back();
                }
                await Get.showSnackbar(GetBar(
                  message: resultMessage,
                  backgroundColor: Colors.black54,
                  snackPosition: SnackPosition.BOTTOM,
                  snackStyle: SnackStyle.FLOATING,
                  isDismissible: true,
                  duration: const Duration(seconds: 2),
                ));
              }
            }),
      );
}
