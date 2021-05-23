import 'package:bloc_sample/feature_puppy/edit/bloc/puppy_edit_form_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/services.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppy_mark_as_favorite_bloc.dart';
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
  Widget build(BuildContext context) {
    puppyPublic = _puppy;
    return
      BlocProvider(
        create: (context) => PuppyEditFormBloc(puppy: _puppy),
        child: Builder(
          builder: (context) {
            final formBloc = BlocProvider.of<PuppyEditFormBloc>(context);

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
                      BlocBuilder<PuppyMarkAsFavoriteBloc, PuppyMarkAsFavoriteState>(
                        builder: (context, state) =>
                            PuppyEditAvatar(
                              heroTag:
                              '$PuppyCardAnimationTag ${_puppy?.id ??
                                  'newpuppy'}',
                              imgPath: _puppy!.asset,
                              pickImage: (source) {
                                if (source != null) {
                                  // BlocProvider.of<PuppyManageBloc>(context)
                                  //     .add(PuppyManageSetImageEvent(source));
                                }
                              },
                            ),
                      ),
                      const SizedBox(height: 20),
                      PuppyEditCard(
                        label: 'Name',
                        content: _buildNameField(formBloc),
                        icon: Icons.account_box,
                      ),
                      PuppyEditCard(
                        label: 'Breed',
                        content: _buildBreedSelection(formBloc),
                        icon: Icons.pets,
                      ),
                      PuppyEditCard(
                        label: 'Gender',
                        content: _buildGenderSelection(formBloc),
                        icon: Icons.wc,
                      ),
                      PuppyEditCard(
                        label: 'Characteristics',
                        content: _buildCharacteristicsField(formBloc),
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
  }

  Widget _buildNameField(PuppyEditFormBloc formBloc) => TextFieldBlocBuilder(
        textFieldBloc: formBloc.name,
        cursorColor: const Color(0xff333333),
        style: TextStyles.editableTextStyle,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        maxLengthEnforced: MaxLengthEnforcement.enforced,
      );

  Widget _buildBreedSelection(PuppyEditFormBloc formBloc) =>
      DropdownFieldBlocBuilder(
        selectFieldBloc: formBloc.breed,
        itemBuilder: (context, value) => value.toString().substring(10),
      );

  Widget _buildGenderSelection(PuppyEditFormBloc formBloc) => Column(
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

