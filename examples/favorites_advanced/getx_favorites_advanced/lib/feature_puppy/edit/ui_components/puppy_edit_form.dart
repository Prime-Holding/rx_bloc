import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import 'package:getx_favorites_advanced/feature_puppy/controllers/puppy_manage_controller.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/ui_components/edit_form_item.dart';

class PuppyEditForm extends StatelessWidget {
  PuppyEditForm(this.globalFormKey, Puppy puppy)
      : nameController = TextEditingController(text: puppy.name),
        characteristicsController =
            TextEditingController(text: puppy.breedCharacteristics);

  final TextEditingController nameController;
  final TextEditingController characteristicsController;
  final GlobalKey<FormState> globalFormKey;
  final controller = Get.find<PuppyManageController>(tag: 'Edit');

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Obx(
            () => Form(
              key: globalFormKey,
              autovalidateMode: controller.validateEnabled.value
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  _buildPuppyAvatar(),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildNameFormField(),
                  _buildBreedDropDownButton(),
                  _buildGenderRadioButtons(),
                  _buildCharacteristicsFormField(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildPuppyAvatar() => Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Card(
              elevation: 3,
              shape: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Obx(
                  () => PuppyAvatar(
                    asset: controller.pickedImagePath.isNotEmpty
                        ? controller.pickedImagePath
                        : controller.asset.value,
                    radius: 128,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 1,
              bottom: 1,
              child: Card(
                elevation: 5,
                shape: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 24,
                      ),
                      onPressed: () => editPicture()),
                ),
              ),
            )
          ],
        ),
      );

  void editPicture() {
    Get.bottomSheet(BottomSheet(
        onClosing: () => Get.close(1),
        builder: (_) => Container(
          height: 120,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_enhance_rounded),
                    title: const Text('Camera'),
                    onTap: () {
                      controller.pickImage(ImagePickerAction.camera);
                      Get.back();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    onTap: () {
                      controller.pickImage(ImagePickerAction.gallery);
                      Get.back();
                    },
                  ),
                ],
              ),
            )));
  }

  Widget _buildNameFormField() => EditFormItem(
        icon: Icons.account_box,
        title: 'Name',
        formField: TextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          validator: (value) => controller.validateName(value),
          onSaved: (value) => controller.setName(value!),
          onChanged: (value) => controller.changeLocalName(value),
          maxLines: 1,
          textInputAction: TextInputAction.next,
          style: TextStyles.editableTextStyle,
        ),
      );

  Widget _buildBreedDropDownButton() => EditFormItem(
        icon: Icons.pets,
        title: 'Breed',
        formField: Obx(
          () => DropdownButton<BreedType>(
            hint: Obx(
              () => Text(controller.breed.toString().substring(10)),
            ),
            value: controller.breed,
            style: TextStyles.editableTextStyle,
            onChanged: (value) => controller.handleBreedChanging(value!),
            items: _buildMenuItems(),
          ),
        ),
      );

  List<DropdownMenuItem<BreedType>> _buildMenuItems() => BreedType.values
      .map((e) => DropdownMenuItem<BreedType>(
          value: e, child: Text(e.toString().substring(10))))
      .toList();

  Widget _buildGenderRadioButtons() => EditFormItem(
        icon: Icons.wc,
        title: 'Gender',
        formField: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Text(
                  'Male',
                  style: TextStyles.editableTextStyle,
                ),
                Obx(
                  () => Radio<Gender>(
                    key: const ValueKey('PuppyGenderMale'),
                    value: Gender.Male,
                    groupValue: controller.gender,
                    onChanged: (value) =>
                        controller.handleGenderChanging(value ?? Gender.None),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Female',
                  style: TextStyles.editableTextStyle,
                ),
                Obx(
                  () => Radio<Gender>(
                    key: const ValueKey('PuppyGenderFemale'),
                    value: Gender.Female,
                    groupValue: controller.gender,
                    onChanged: (value) =>
                        controller.handleGenderChanging(value ?? Gender.None),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildCharacteristicsFormField() => EditFormItem(
        icon: Icons.article,
        title: 'Characteristics',
        formField: TextFormField(
          controller: characteristicsController,
          keyboardType: TextInputType.text,
          validator: (value) => controller.validateCharacteristics(value),
          onSaved: (value) => controller.setCharacteristics(value!),
          onChanged: (value) => controller.changeLocalCharacteristics(value),
          maxLines: 8,
          textInputAction: TextInputAction.next,
          style: TextStyles.editableTextStyle,
        ),
      );
}
