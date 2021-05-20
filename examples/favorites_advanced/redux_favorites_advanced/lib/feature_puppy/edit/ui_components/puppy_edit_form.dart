import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';

import '../ui_components/puppy_edit_card.dart';
import '../views/puppy_edit_view_model.dart';
import 'puppy_edit_avatar.dart';

class PuppyEditForm extends StatelessWidget {
  const PuppyEditForm({
    required GlobalKey<FormState> formKey,
    required PuppyEditViewModel viewModel,
    Key? key,
  })  : _formKey = formKey,
        _viewModel = viewModel,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final PuppyEditViewModel _viewModel;

  @override
  Widget build(BuildContext context) => SafeArea(
          child: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            autovalidateMode: (_viewModel.isSubmitAttempted)
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                PuppyEditAvatar(
                  heroTag: '$PuppyCardAnimationTag ${_viewModel.puppy.id}',
                  imgPath: _viewModel.puppy.asset,
                  pickImage: (source) => _viewModel.onImagePicker(source!),
                ),
                PuppyEditCard(
                  label: 'Name',
                  content: TextFormField(
                    key: const ValueKey('PuppyNameInputField'),
                    //controller: _nameController,
                    maxLines: 1,
                    initialValue: _viewModel.puppy.name,
                    cursorColor: const Color(0xff333333),
                    style: TextStyles.editableTextStyle,
                    textInputAction: TextInputAction.next,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    onChanged: (name) => _viewModel.onNameChange(name),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Name must not be empty.'
                        : (value.length > 30)
                            ? 'Name too long.'
                            : null,
                  ),
                  icon: Icons.account_box,
                ),
                PuppyEditCard(
                  label: 'Breed',
                  content: Column(
                    children: [
                      Center(
                        child: DropdownButton<BreedType>(
                          key: const ValueKey('PuppyBreedTypeDropDown'),
                          value: _viewModel.puppy.breedType,
                          onChanged: (breed) =>
                              _viewModel.onBreedChange(breed!),
                          items: BreedType.values
                              .map(
                                (breedType) => DropdownMenuItem<BreedType>(
                                  value: breedType,
                                  child: Text(
                                    PuppyDataConversion.getBreedTypeString(
                                        breedType)!,
                                    style: TextStyles.editableTextStyle,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  icon: Icons.pets,
                ),
                PuppyEditCard(
                  label: 'Gender',
                  content: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Male',
                                style: TextStyles.editableTextStyle,
                              ),
                              Radio<Gender>(
                                key: const ValueKey('PuppyGenderMaleRadio'),
                                value: Gender.Male,
                                groupValue: _viewModel.puppy.gender,
                                onChanged: (gender) =>
                                    _viewModel.onGenderChange(gender!),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Female',
                                style: TextStyles.editableTextStyle,
                              ),
                              Radio<Gender>(
                                key: const ValueKey('PuppyGenderFemaleRadio'),
                                value: Gender.Female,
                                groupValue: _viewModel.puppy.gender,
                                onChanged: (gender) =>
                                    _viewModel.onGenderChange(gender!),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  icon: Icons.wc,
                ),
                PuppyEditCard(
                  label: 'Characteristics',
                  content: TextFormField(
                    key: const ValueKey('PuppyCharacteristicsInputField'),
                    maxLines: 8,
                    initialValue: _viewModel.puppy.breedCharacteristics,
                    cursorColor: const Color(0xff333333),
                    style: TextStyles.editableTextStyle,
                    textInputAction: TextInputAction.done,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    onChanged: (characteristics) =>
                        _viewModel.onCharacteristicsChange(characteristics),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Characteristics must not be empty.'
                        : (value.length > 250)
                            ? 'Characteristics must not exceed 250 characters.'
                            : null,
                  ),
                  icon: Icons.article,
                ),
              ],
            ),
          ),
        ),
      ));
}
