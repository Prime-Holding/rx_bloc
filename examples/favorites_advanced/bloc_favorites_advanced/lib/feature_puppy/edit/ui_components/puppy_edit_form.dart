import 'package:bloc_sample/feature_puppy/edit/bloc/puppy_edit_form_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/services.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:provider/provider.dart';

import 'image_field_bloc_builder.dart';

// ignore: must_be_immutable
class PuppyEditForm extends StatelessWidget {
  PuppyEditForm({
    required Puppy puppy,
    required PuppyEditFormBloc puppyEditFormBloc,
    Key? key,
  })  : _puppy = puppy,
        _formBloc = puppyEditFormBloc,
        breedHasError = false,
        super(key: key);

  final Puppy _puppy;
  final PuppyEditFormBloc _formBloc;
  bool breedHasError;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => PuppyEditFormBloc(
          coordinatorBloc: context.read(),
          repository: context.read(),
          puppy: _puppy,
        ),
        child: Builder(
          builder: (context) => SafeArea(
            key: const ValueKey('PuppyEditPage'),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: FocusScope(
                  child: Column(
                    children: [
                      _buildImage(_formBloc),
                      const SizedBox(height: 20),
                      PuppyEditCard(
                        label: 'Name',
                        content: _buildNameField(_formBloc),
                        icon: Icons.account_box,
                      ),
                      PuppyEditCard(
                        label: 'Breed',
                        content: _buildBreedSelection(_formBloc),
                        icon: Icons.pets,
                      ),
                      PuppyEditCard(
                        label: 'Gender',
                        content: _buildGenderSelection(_formBloc),
                        icon: Icons.wc,
                      ),
                      PuppyEditCard(
                        label: 'Characteristics',
                        content: _buildCharacteristicsField(_formBloc),
                        icon: Icons.article,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildImage(PuppyEditFormBloc formBloc) => ImageFieldBlocBuilder(
        fileFieldBloc: formBloc.image,
        puppyEditFormBloc: _formBloc,
        puppy: _puppy,
      );

  Widget _buildNameField(PuppyEditFormBloc formBloc) => TextFieldBlocBuilder(
        textFieldBloc: formBloc.name,
        cursorColor: const Color(0xff333333),
        style: TextStyles.editableTextStyle,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        maxLengthEnforced: MaxLengthEnforcement.enforced,
      );

  Widget _buildBreedSelection(PuppyEditFormBloc formBloc) =>
      StreamBuilder<String>(
        stream: formBloc.breedError$,
        builder: (context, snapshot) {
          final result = snapshot.data != null ? true : false;
          if (result) {
            if (snapshot.data!.isNotEmpty) {
              breedHasError = true;
            }
          }
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButton<BreedType>(
                    value: formBloc.breed.value,
                    style: TextStyles.editableTextStyle,
                    onChanged: (value) => formBloc.breed.updateValue(value!),
                    items: _buildMenuItems(),
                    underline: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: breedHasError
                                ? Colors.red
                                : Colors.grey.shade800,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (breedHasError)
                    Row(
                      children: [
                        Text(
                          snapshot.data!,
                          style: TextStyles.errorTextStyle,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      );

  List<DropdownMenuItem<BreedType>>? _buildMenuItems() => BreedType.values
      .map((e) => DropdownMenuItem<BreedType>(
          value: e, child: Text(e.toString().substring(10))))
      .toList();

  Widget _buildGenderSelection(PuppyEditFormBloc formBloc) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: RadioButtonGroupFieldBlocBuilder(
                  selectFieldBloc: formBloc.gender,
                  itemBuilder: (context, value) =>
                      value.toString().substring(7),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildCharacteristicsField(PuppyEditFormBloc formBloc) =>
      TextFieldBlocBuilder(
        textFieldBloc: formBloc.characteristics,
        cursorColor: const Color(0xff333333),
        key: const ValueKey('PuppyCharacteristicsInputField'),
        style: TextStyles.editableTextStyle,
        textInputAction: TextInputAction.done,
        maxLines: 8,
        maxLengthEnforced: MaxLengthEnforcement.enforced,
      );
}
