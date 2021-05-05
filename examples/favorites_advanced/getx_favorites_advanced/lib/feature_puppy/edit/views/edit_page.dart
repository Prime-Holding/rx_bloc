import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/controllers/puppy_editing_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/ui_components/puppy_edit_form.dart';

class EditPage extends GetView<PuppyEditingController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Puppy'),
          actions: [
            _buildSaveIcon(),
          ],
        ),
    body: PuppyEditForm(),
      );

  Widget _buildSaveIcon() => IconButton(
          icon: controller.isLoading.value
              ? Container(
              height: 24,
              width: 24,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ))
              : Icon(
            Icons.save,
            color: controller.isSaveEnabled.value ? Colors.white : Colors.grey,
          ),
          onPressed: () {
            if (controller.isSaveEnabled.value) {
              // TODO implement saving
            }
          });
}
