import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_favorites_advanced/feature_puppy/edit/controllers/puppy_editing_controller.dart';

class PuppyEditForm extends GetView<PuppyEditingController> {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: controller.globalFormKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                _createPuppyAvatar(),
                const SizedBox(
                  height: 16,
                ),
                EditFormItem(
                  icon: Icons.account_box,
                  title: 'Name',
                  formField: TextFormField(
                    controller: controller.nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) => controller.validateName(value),
                    onSaved: (value) => controller.setName(value!),
                    onChanged: (value) => controller.changeLocalName(value),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                EditFormItem(
                  icon: Icons.pets,
                  title: 'Breed',
                  formField: DropdownButtonFormField(
                    items: [
                      DropdownMenuItem(child: Text(BreedType.Akita.toString()))
                    ],
                  ),
                ),
                EditFormItem(
                  icon: Icons.wc,
                  title: 'Gender',
                  formField: Row(
                    children: [
                      Obx(
                        () => Radio(
                          key: const ValueKey('PuppyGenderMale'),
                          value: 1,
                          groupValue: controller.radioGroup.value,
                          onChanged: (value) =>
                              controller.handleGenderChanging(value as int),
                        ),
                      ),
                      const Text('Male'),
                      Obx(
                        () => Radio(
                          key: const ValueKey('PuppyGenderFemale'),
                          value: 2,
                          groupValue: controller.radioGroup.value,
                          onChanged: (value) =>
                              controller.handleGenderChanging(value as int),
                        ),
                      ),
                      const Text('Female'),
                    ],
                  ),
                ),
                EditFormItem(
                  icon: Icons.article,
                  title: 'Characteristics',
                  formField: TextFormField(
                    controller: controller.characteristicsController,
                    keyboardType: TextInputType.text,
                    validator: (value) =>
                        controller.validateCharacteristics(value),
                    onSaved: (value) => controller.setCharacteristics(value!),
                    onChanged: (value) =>
                        controller.changeLocalCharacteristics(value),
                    maxLines: 8,
                    textInputAction: TextInputAction.next,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _createPuppyAvatar() => Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Card(
              elevation: 3,
              shape: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: PuppyAvatar(
                  asset: controller.asset.value,
                  radius: 128,
                ),
              ),
            ),
            const Positioned(
                right: 1,
                bottom: 1,
                child: Card(
                  elevation: 5,
                  shape: CircleBorder(),
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.edit,
                        size: 26,
                      )),
                ))
          ],
        ),
      );
}

class EditFormItem extends StatelessWidget {
  const EditFormItem({
    required IconData icon,
    required String title,
    required Widget formField,
    Key? key,
  })  : _title = title,
        _icon = icon,
        _formField = formField,
        super(key: key);

  final IconData _icon;
  final String _title;
  final Widget _formField;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    _icon,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    _title,
                    style: TextStyles.editableTextStyle
                        .copyWith(color: Colors.black54),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              _formField,
            ],
          ),
        ),
      );
}
