import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/services.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_avatar.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PuppyEditForm extends StatelessWidget {
  const PuppyEditForm({
    Puppy? puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy? _puppy;

  @override
  Widget build(BuildContext context) => SafeArea(
        key: const ValueKey('PuppyEditPage'),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // BlocListener<PuppyManageBloc, PuppyManageState>(
                //   listener: (context, state) {
                //     ///TODO change this
                //     if(state.updateComplete != null){
                //       context.flow<PuppyFlowState>().complete();
                //     }
                //   },
                // ),
                // BlocListener<PuppyManageBloc, PuppyManageState>(
                //   listener: (context, state){
                //     if(state.error != null){
                //       ScaffoldMessenger.of(context)
                //           .showSnackBar(SnackBar(content:
                //           Text(state.error!)));
                //     }
                //   }
                // ),
                BlocBuilder<PuppyManageBloc, PuppyManageState>(
                  builder: (context, state) => PuppyEditAvatar(
                    heroTag:
                        '$PuppyCardAnimationTag ${_puppy?.id ?? 'newpuppy'}',
                    imgPath: _puppy!.asset,
                    pickImage: (source) {
                      if (source != null) {
                        BlocProvider.of<PuppyManageBloc>(context)
                            .add(PuppyManageSetImageEvent(source));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                PuppyEditCard(
                  label: 'Name',
                  content: _buildNameField(),
                  icon: Icons.account_box,
                ),
                PuppyEditCard(
                  label: 'Breed',
                  content: _buildBreedSelection(),
                  icon: Icons.pets,
                ),
                PuppyEditCard(
                  label: 'Gender',
                  content: _buildGenderSelection(),
                  icon: Icons.wc,
                ),
                PuppyEditCard(
                  label: 'Characteristics',
                  content: _buildCharacteristicsField(),
                  icon: Icons.article,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildNameField() => TextFormField(
        key: const ValueKey('PuppyNameInputField'),
        cursorColor: const Color(0xff333333),
        style: TextStyles.editableTextStyle,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        // controller: fieldState.controller,
        // decoration: fieldState.decoration!
        //     .copyWithDecoration(InputStyles.textFieldDecoration),
      );

  Widget _buildBreedSelection() => Column(
        children: [
          Center(
            child: DropdownButton<BreedType>(
              key: const ValueKey('PuppyBreedTypeDropDown'),
              value: BreedType.Akita,
              onChanged: (breed) => {},
              items: BreedType.values
                  .map(
                    (breedType) => DropdownMenuItem<BreedType>(
                      value: breedType,
                      child: Text(
                        PuppyDataConversion.getBreedTypeString(breedType)!,
                        style: TextStyles.editableTextStyle,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );

  Widget _buildGenderSelection() => Column(
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
                    groupValue: null,
                    onChanged: (gender) {},
                    // onChanged:(gender) => BlocProvider
                    // .of<PuppyManageBloc>(context)
                    // .add(
                    // PuppyManageSetGenderEvent(gender ?? Gender.None),
                    // ),
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
                    groupValue: null,
                    onChanged: (gender) => {},
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  Widget _buildCharacteristicsField() => TextFormField(
        cursorColor: const Color(0xff333333),
        key: const ValueKey('PuppyCharacteristicsInputField'),
        style: TextStyles.editableTextStyle,
        textInputAction: TextInputAction.done,
        maxLines: 8,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        // controller: fieldState.controller,
        // decoration: fieldState.decoration!
        //     .copyWithDecoration(InputStyles.textFieldDecoration),
      );
}
