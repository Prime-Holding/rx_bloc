import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:bloc_sample/feature_puppy/edit/bloc/puppy_edit_form_bloc.dart';

class ImageFieldBlocBuilder extends StatelessWidget {
  const ImageFieldBlocBuilder({
    required this.puppy,
    required this.fileFieldBloc,
    required this.formBloc,
  });

  final InputFieldBloc<ImagePickerAction, Object> fileFieldBloc;
  final FormBloc formBloc;
  final Puppy puppy;

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        final puppyEditFormBloc = BlocProvider.of<PuppyEditFormBloc>(context);
        return StreamBuilder<String>(
            stream: puppyEditFormBloc.asset$,
            builder: (context, snapshot) => PuppyEditAvatar(
                  // print('image_field_bloc_builder: ${snapshot.data}');

                  fileFieldBloc: fileFieldBloc,
                  formBloc: formBloc,
                  heroTag: '$PuppyCardAnimationTag ${puppy.id}',
                  imgPath: snapshot.data ?? puppy.asset,
                  pickImage: (source) {
                    if (source != null) {}
                  },
                ));
      });
}
