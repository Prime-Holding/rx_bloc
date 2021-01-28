import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/input_styles.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/text_styles.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/edit/ui_components/puppy_edit_avatar.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/edit/ui_components/puppy_edit_card.dart';

class PuppyEditForm extends StatelessWidget {
  const PuppyEditForm({
    Puppy puppy,
    Key key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy _puppy;

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
                    if (result) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                RxBlocListener<PuppyManageBlocType, String>(
                  state: (bloc) => bloc.states.error,
                  listener: (context, error) {
                    if (error != null) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(error)));
                    }
                  },
                ),
                RxBlocBuilder<PuppyManageBlocType, String>(
                  state: (bloc) => bloc.states.imagePath,
                  builder: (context, snapshot, bloc) => PuppyEditAvatar(
                    heroTag: '$PuppyCardAnimationTag ${_puppy.id}',
                    imgPath: snapshot.data ?? _puppy.asset,
                    pickImage: (source) => bloc.events.setImage(source),
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
        decorationData: InputStyles.textFieldDecorationData,
        builder: (fieldState) => TextFormField(
          key: const ValueKey('PuppyNameInputField'),
          cursorColor: const Color(0xff333333),
          style: TextStyles.editableTextStyle,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          maxLengthEnforced: true,
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
        decorationData: InputStyles.textFieldDecorationData,
        builder: (fieldState) => TextFormField(
          cursorColor: const Color(0xff333333),
          key: const ValueKey('PuppyCharacteristicsInputField'),
          style: TextStyles.editableTextStyle,
          textInputAction: TextInputAction.done,
          maxLines: 8,
          maxLengthEnforced: true,
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
                onChanged: fieldState.bloc.events.setBreed,
                items: BreedType.values
                    .map(
                      (breedType) => DropdownMenuItem<BreedType>(
                        value: breedType,
                        child: Text(
                          PuppyDataConversion.getBreedTypeString(breedType),
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
                    fieldState.error,
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
                      onChanged: fieldState.bloc.events.setGender,
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
                      onChanged: fieldState.bloc.events.setGender,
                    ),
                  ],
                ),
              ],
            ),
            if (fieldState.showError)
              Row(
                children: [
                  Text(
                    fieldState.error,
                    style: TextStyles.errorTextStyle,
                  ),
                ],
              ),
          ],
        ),
      );
}
