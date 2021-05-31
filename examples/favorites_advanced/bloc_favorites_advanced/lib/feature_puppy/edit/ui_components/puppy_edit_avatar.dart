import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class PuppyEditAvatar extends StatelessWidget {
  const PuppyEditAvatar({
    required this.fileFieldBloc,
    required this.heroTag,
    required this.imgPath,
    Key? key,
  }) : super(key: key);
  final InputFieldBloc<ImagePickerAction, Object> fileFieldBloc;
  final String heroTag;
  final String imgPath;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Hero(
            tag: heroTag,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
              ),
              child: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PuppyAvatar(
                      asset: imgPath,
                      radius: 128,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 1,
            bottom: 1,
            child: Card(
              elevation: 5,
              shape: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 24,
                  ),
                  onPressed: () => editPicture(context),
                ),
              ),
            ),
          ),
        ],
      );

  // ignore: avoid_void_async
  void editPicture(BuildContext context) async {
    await showModalBottomSheet<ImagePickerAction>(
      context: context,
      builder: (context) => Container(
        height: 150,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.camera_enhance),
                  title: const Text('Camera'),
                  onTap: () {
                    // print('Camera1');
                    fileFieldBloc.updateValue(ImagePickerAction.camera);
                    Navigator.of(context).pop(ImagePickerAction.camera);
                  }),
              ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Gallery'),
                  onTap: () {
                    // print('Gallery1');
                    fileFieldBloc.updateValue(ImagePickerAction.gallery);
                    Navigator.of(context).pop(ImagePickerAction.gallery);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
