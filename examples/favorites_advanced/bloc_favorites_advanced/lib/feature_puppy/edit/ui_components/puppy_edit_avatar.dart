import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';

class PuppyEditAvatar extends StatelessWidget {
  const PuppyEditAvatar({
    required this.heroTag,
    required this.imgPath,
    required this.pickImage,
    Key? key,
  }) : super(key: key);

  final String heroTag;
  final String imgPath;
  final void Function(ImagePickerAction? source) pickImage;

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              child: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // print('presentPhotosBottomSheet source: ');
                      PhotoPickerActionSelectionBottomSheet
                          .presentPhotosBottomSheet(
                        context,
                        (source) => pickImage(source),
                        // print('presentPhotosBottomSheet source: ${source}');
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.edit,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
