import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/color_styles.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/text_styles.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/edit/ui_components/puppy_edit_avatar.dart';

class PuppyEditForm extends StatelessWidget {
  const PuppyEditForm({
    this.tag,
    Key key,
  }) : super(key: key);

  final dynamic tag;

  @override
  Widget build(BuildContext context) => SafeArea(
        key: const ValueKey('PuppyEditPage'),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                RxBlocBuilder<PuppyManageBlocType, String>(
                  state: (bloc) => bloc.states.imagePath,
                  builder: (context, snapshot, bloc) => snapshot.hasData
                      ? PuppyEditAvatar(
                          heroTag: tag,
                          imgPath: snapshot.data,
                          pickImage: (source) => bloc.events.pickImage(source),
                        )
                      : LoadingWidget(),
                ),
                const SizedBox(height: 20),
                _buildRow(
                  'Name',
                  _buildNameField(),
                  icon: Icons.account_box,
                ),
                _buildRow(
                  'Breed',
                  _buildBreedSelection(),
                  icon: Icons.pets,
                ),
                _buildRow(
                  'Gender',
                  _buildGenderSelection(),
                  icon: Icons.wc,
                ),
                _buildRow(
                  'Characteristics',
                  _buildCharacteristicsField(),
                  icon: Icons.article,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildRow(String rowName, Widget content, {IconData icon}) => Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      size: 18,
                      color: ColorStyles.textColor,
                    ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    rowName,
                    style: TextStyles.title2TextStyleBlack,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              const Divider(
                thickness: 1,
                height: 1,
              ),
              const SizedBox(
                height: 8,
              ),
              if (content != null) content,
            ],
          ),
        ),
      );

  Widget _buildNameField() => RxTextFormFieldBuilder<PuppyManageBlocType>(
        state: (bloc) => bloc.states.name,
        showError: (bloc) => bloc.states.showErrors,
        onChanged: (bloc, value) => bloc.events.updateName(value),
        builder: (decoration, controller) => TextFormField(
          key: const ValueKey('PuppyNameInputField'),
          style: TextStyles.editableTextStyle,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          maxLengthEnforced: true,
          controller: controller,
          decoration: decoration,
        ),
      );

  Widget _buildCharacteristicsField() =>
      RxTextFormFieldBuilder<PuppyManageBlocType>(
        state: (bloc) => bloc.states.characteristics,
        showError: (bloc) => bloc.states.showErrors,
        onChanged: (bloc, value) => bloc.events.updateCharacteristics(value),
        builder: (decoration, controller) => TextFormField(
          key: const ValueKey('PuppyCharacteristicsInputField'),
          style: TextStyles.editableTextStyle,
          textInputAction: TextInputAction.done,
          maxLines: 8,
          maxLengthEnforced: true,
          controller: controller,
          decoration: decoration,
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
                onChanged: fieldState.bloc.events.updateBreed,
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
            if (fieldState.showError && fieldState.error != null)
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
        builder: (state) => Column(
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
                      groupValue: state.value,
                      onChanged: state.bloc.events.updateGender,
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
                      groupValue: state.value,
                      onChanged: state.bloc.events.updateGender,
                    ),
                  ],
                ),
              ],
            ),
            if (state.showError && state.error != null)
              Row(
                children: [
                  Text(
                    state.error,
                    style: TextStyles.errorTextStyle,
                  ),
                ],
              ),
          ],
        ),
      );
}
