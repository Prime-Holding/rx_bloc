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
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class PuppyEditForm extends StatelessWidget {
  const PuppyEditForm({
    Puppy? puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy? _puppy;
  static Puppy? puppyPublic;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => EditFormBloc(),
        child: Builder(
          builder: (context) {
            final formBloc = BlocProvider.of<EditFormBloc>(context);
            puppyPublic = _puppy;

            return SafeArea(
              key: const ValueKey('PuppyEditPage'),
              child: SingleChildScrollView(
                // physics: const ClampingScrollPhysics(),
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
                              '$PuppyCardAnimationTag ${_puppy?.id ??
                                  'newpuppy'}',
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
                        // content: _buildNameField(),
                        content: _buildNameField1(formBloc),
                        icon: Icons.account_box,
                      ),
                      PuppyEditCard(
                        label: 'Breed',
                        // content: _buildBreedSelection(),
                        content: _buildBreedSelection1(formBloc),
                        icon: Icons.pets,
                      ),
                      // RadioButtonGroupFieldBlocBuilder(
                      //   selectFieldBloc: formBloc.gender,
                      //   itemBuilder: (context, value) => value.toString(),
                      //   decoration: const InputDecoration(
                      //     labelText: 'Do you like form bloc?',
                      //     prefixIcon: SizedBox(),
                      //   ),
                      // ),
                      PuppyEditCard(
                        label: 'Gender',
                        // content: _buildGenderSelection(),
                        content: _buildGenderSelection1(formBloc),
                        icon: Icons.wc,
                      ),
                      PuppyEditCard(
                        label: 'Characteristics',
                        // content: _buildCharacteristicsField(),
                        content: _buildCharacteristicsField1(formBloc),
                        icon: Icons.article,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildNameField1(EditFormBloc formBloc) => TextFieldBlocBuilder(
        textFieldBloc: formBloc.name,
        cursorColor: const Color(0xff333333),
        style: TextStyles.editableTextStyle,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        maxLengthEnforced: MaxLengthEnforcement.enforced,
      );

  Widget _buildNameField() => TextFormField(
        initialValue: _puppy!.name,
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

  Widget _buildBreedSelection1(EditFormBloc formBloc) =>
      DropdownFieldBlocBuilder(
        selectFieldBloc: formBloc.breed,
        itemBuilder: (context, value) => value.toString().substring(10),
      );

  Widget _buildBreedSelection() => Column(
        children: [
          Center(
            child: DropdownButton<BreedType>(
              key: const ValueKey('PuppyBreedTypeDropDown'),
              value: _puppy!.breedType,
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

  Widget _buildGenderSelection1(EditFormBloc formBloc) => Column(
        // mainAxisSize: ,
        children: [
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: RadioButtonGroupFieldBlocBuilder(
                  selectFieldBloc: formBloc.gender,
                  itemBuilder: (context, value) => value.toString(),
                ),
              ),
            ],
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

  Widget _buildCharacteristicsField1(EditFormBloc formBloc) =>
      TextFieldBlocBuilder(
        textFieldBloc: formBloc.characteristics,
        cursorColor: const Color(0xff333333),
        key: const ValueKey('PuppyCharacteristicsInputField'),
        style: TextStyles.editableTextStyle,
        textInputAction: TextInputAction.done,
        maxLines: 8,
        maxLengthEnforced: MaxLengthEnforcement.enforced,
      );

  Widget _buildCharacteristicsField() => TextFormField(
        initialValue: _puppy!.displayCharacteristics,
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

class EditFormBloc extends FormBloc<String, String> {
  EditFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        name,
        breed,
        gender,
        characteristics,
      ],
    );
  }

  final name = TextFieldBloc(
    initialValue: 'InitialName',
    validators: [FieldBlocValidators.required],
  );

  final breed = SelectFieldBloc(
    items: BreedType.values,
    initialValue: BreedType.Akita,
  );

  final gender = SelectFieldBloc(
    name: 'gender',
    items: ['Male', 'Female'],
    initialValue: 'Male',
    // initialValue: PuppyEditForm.puppyPublic?.gender.toString(),
    // items: [Gender.Male.toString(),Gender.Female.toString()],
    validators: [FieldBlocValidators.required],
  );

  final characteristics = TextFieldBloc(
    initialValue: 'initial characteristics',
    validators: [FieldBlocValidators.required],
  );

  @override
  void onSubmitting() {
    // TODO: implement onSubmitting
  }
}
