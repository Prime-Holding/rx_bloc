import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

import '../../../base/flow_builders/puppy_flow.dart';
import '../../../base/resources/rx_input_styles.dart';
import '../../blocs/puppy_manage_bloc.dart';
import 'puppy_edit_avatar.dart';

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
                RxBlocListener<PuppyManageBlocType, bool>(
                  state: (bloc) => bloc.states.updateComplete,
                  listener: (context, result) {
                    if (result!) {
                      context.flow<PuppyFlowState>().complete();
                    }
                  },
                ),
                RxBlocListener<PuppyManageBlocType, String>(
                  state: (bloc) => bloc.states.error,
                  listener: (context, error) {
                    if (error != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(error)));
                    }
                  },
                ),
                RxBlocBuilder<PuppyManageBlocType, String>(
                  state: (bloc) => bloc.states.imagePath,
                  builder: (context, snapshot, bloc) => PuppyEditAvatar(
                    heroTag:
                        '$PuppyCardAnimationTag ${_puppy?.id ?? 'newpuppy'}',
                    imgPath: snapshot.data ?? _puppy!.asset,
                    pickImage: (source) {
                      if (source != null) {
                        bloc.events.setImage(source);
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

  Widget _buildNameField() => RxTextFormFieldBuilder<PuppyManageBlocType>(
        state: (bloc) => bloc.states.name,
        showErrorState: (bloc) => bloc.states.showErrors,
        onChanged: (bloc, value) => bloc.events.setName(value),
        //optional
        decorationData: RxInputStyles.textFieldDecorationData,
        builder: (fieldState) => TextFormField(
          key: const ValueKey('PuppyNameInputField'),
          cursorColor: const Color(0xff333333),
          style: TextStyles.editableTextStyle,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: fieldState.controller,
          decoration: fieldState.decoration
              .copyWithDecoration(InputStyles.textFieldDecoration),
        ),
      );

  Widget _buildCharacteristicsField() =>
      RxTextFormFieldBuilder<PuppyManageBlocType>(
        state: (bloc) => bloc.states.characteristics,
        showErrorState: (bloc) => bloc.states.showErrors,
        onChanged: (bloc, value) => bloc.events.setCharacteristics(value),
        decorationData: RxInputStyles.textFieldDecorationData,
        builder: (fieldState) => TextFormField(
          cursorColor: const Color(0xff333333),
          key: const ValueKey('PuppyCharacteristicsInputField'),
          style: TextStyles.editableTextStyle,
          textInputAction: TextInputAction.done,
          maxLines: 8,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: fieldState.controller,
          decoration: fieldState.decoration
              .copyWithDecoration(InputStyles.textFieldDecoration),
        ),
      );

  Widget _buildBreedSelection() =>
      RxFormFieldBuilder<PuppyManageBlocType, BreedType>(
        state: (bloc) => bloc.states.breed,
        showErrorState: (bloc) => bloc.states.showErrors,
        builder: (fieldState) => Column(
          children: [
            Center(
              child: DropdownButton<BreedType>(
                key: const ValueKey('PuppyBreedTypeDropDown'),
                value: fieldState.value,
                onChanged: (breed) =>
                    fieldState.bloc.events.setBreed(breed ?? BreedType.None),
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
            if (fieldState.showError)
              Row(
                children: [
                  Text(
                    fieldState.error!,
                    style: TextStyles.errorTextStyle,
                  ),
                ],
              ),
          ],
        ),
      );

  Widget _buildGenderSelection() =>
      RxFormFieldBuilder<PuppyManageBlocType, Gender>(
        state: (bloc) => bloc.states.gender,
        showErrorState: (bloc) => bloc.states.showErrors,
        builder: (fieldState) => Column(
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
                      groupValue: fieldState.value,
                      onChanged: (gender) => fieldState.bloc.events
                          .setGender(gender ?? Gender.None),
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
                      groupValue: fieldState.value,
                      onChanged: (gender) => fieldState.bloc.events
                          .setGender(gender ?? Gender.None),
                    ),
                  ],
                ),
              ],
            ),
            if (fieldState.showError)
              Row(
                children: [
                  Text(
                    fieldState.error!,
                    style: TextStyles.errorTextStyle,
                  ),
                ],
              ),
          ],
        ),
      );
}
