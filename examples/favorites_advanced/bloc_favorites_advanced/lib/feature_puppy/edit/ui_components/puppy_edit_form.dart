// import 'package:bloc_sample/base/flow_builders/puppy_flow.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_avatar.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_card.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flow_builder/flow_builder.dart';

class PuppyEditForm extends StatelessWidget{
  const PuppyEditForm({
    Puppy? puppy,
    Key? key,
}) : _puppy = puppy,
  super(key: key);

  final Puppy? _puppy;

  @override
  Widget build(BuildContext context) => SafeArea(
    key: const ValueKey('PuppyEditPage'),
    child: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children:[
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
            //           .showSnackBar(SnackBar(content: Text(state.error!)));
            //     }
            //   }
            // ),
            BlocBuilder<PuppyManageBloc, PuppyManageState>(
              builder: (context, state) => PuppyEditAvatar(
                heroTag:'$PuppyCardAnimationTag ${_puppy?.id ?? 'newpuppy'}',
                imgPath: _puppy!.asset,
                pickImage: (source){
                  if(source != null){
                    BlocProvider.of<PuppyManageBloc>(context).add(
                        PuppyManageSetImageEvent(
                            source));
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
          ]
        ),
      ),
    ),
  );

  _buildNameField() {}


  _buildBreedSelection() {}

  _buildGenderSelection() {}
  _buildCharacteristicsField() {}
}
















