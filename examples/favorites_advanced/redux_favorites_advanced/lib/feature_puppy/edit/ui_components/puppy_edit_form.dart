import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';

import '../ui_components/puppy_edit_card.dart';
//import '../views/puppy_edit_view_model.dart';
import 'puppy_edit_avatar.dart';

class PuppyEditForm extends StatelessWidget {
  PuppyEditForm({
    Puppy? puppy,
    //PuppyEditViewModel? viewModel,
    Key? key,
  })  : _puppy = puppy,
        //_viewModel = viewModel,
        super(key: key);

  final _formKey = GlobalKey<FormState>();
  final Puppy? _puppy;
  //final PuppyEditViewModel? _viewModel;

  @override
  Widget build(BuildContext context) => SafeArea(
          child: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                PuppyEditAvatar(
                  heroTag: '$PuppyCardAnimationTag ${_puppy?.id ?? 'newpuppy'}',
                  imgPath: _puppy?.asset ?? '',
                  pickImage: (source) {},
                ),
                PuppyEditCard(
                  label: 'Name',
                  content: TextFormField(
                    key: const ValueKey('PuppyNameInputField'),
                    maxLines: 1,
                    initialValue: _puppy!.name,
                    cursorColor: const Color(0xff333333),
                    style: TextStyles.editableTextStyle,
                    textInputAction: TextInputAction.next,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                          value: _puppy!.breedType,
                          onChanged: (breedType) {},
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
                  //content: Text(_puppy!.gender.toString()),
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
                                groupValue: _puppy!.gender,
                                onChanged: (gender) {},
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
                                groupValue: _puppy!.gender,
                                onChanged: (gender) {},
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
                    initialValue: _puppy!.breedCharacteristics,
                    cursorColor: const Color(0xff333333),
                    style: TextStyles.editableTextStyle,
                    textInputAction: TextInputAction.done,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    validator: (value) => (value == null)
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
