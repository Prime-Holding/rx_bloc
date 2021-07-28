import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import '../views/puppy_edit_view_model.dart';
import 'puppy_edit_avatar.dart';

class PuppyEditForm extends StatelessWidget {
  const PuppyEditForm({
    required PuppyEditViewModel viewModel,
    Key? key,
  })  : _viewModel = viewModel,
        super(key: key);

  final PuppyEditViewModel _viewModel;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                PuppyEditAvatar(
                  heroTag: '$PuppyCardAnimationTag ${_viewModel.puppy.id}',
                  imgPath: _viewModel.puppy.asset,
                  pickImage: (source) => _viewModel.onImagePicker(source!),
                ),
                const SizedBox(height: 20),
                PuppyEditCard(
                  label: 'Name',
                  content: TextFormField(
                    key: const ValueKey('PuppyNameInputField'),
                    maxLines: 1,
                    initialValue: _viewModel.puppy.name,
                    cursorColor: const Color(0xff333333),
                    style: TextStyles.editableTextStyle,
                    textInputAction: TextInputAction.next,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: (_viewModel.nameError != '')
                        ? InputStyles.textFieldDecoration
                            .copyWith(errorText: _viewModel.nameError)
                        : InputStyles.textFieldDecoration,
                    onChanged: (name) => _viewModel.onNameChange(name),
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
                    decoration: (_viewModel.characteristicsError != '')
                        ? InputStyles.textFieldDecoration.copyWith(
                            errorText: _viewModel.characteristicsError)
                        : InputStyles.textFieldDecoration,
                    onChanged: (characteristics) =>
                        _viewModel.onCharacteristicsChange(characteristics),
                  ),
                  icon: Icons.article,
                ),
              ],
            ),
          ),
        ),
      );
}
