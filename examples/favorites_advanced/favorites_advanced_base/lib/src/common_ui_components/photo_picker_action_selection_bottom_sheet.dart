import 'dart:io';

import 'package:favorites_advanced_base/src/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoPickerActionSelectionBottomSheet {
  static final _imagePickerTitle = 'Choose Image';
  static final _imagePickerCamera = 'Camera';
  static final _imagePickerGallery = 'Gallery';
  static final _imagePickerCancel = 'Cancel';

  static presentPhotosBottomSheet(
    BuildContext context,
    Function(ImagePickerAction? source) onChooseAction,
  ) {
    if (Platform.isAndroid) {
      _presentMaterialBottomSheet(context, onChooseAction);
    } else {
      _presentCupertinoBottomSheet(context, onChooseAction);
    }
  }

  static void _presentCupertinoBottomSheet(
    BuildContext context,
    Function(ImagePickerAction? source) onChooseAction,
  ) async {
    var result = await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(_imagePickerTitle),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text(_imagePickerCamera),
            onPressed: () =>
                Navigator.of(context).pop(ImagePickerAction.camera),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text(_imagePickerGallery),
            onPressed: () =>
                Navigator.of(context).pop(ImagePickerAction.gallery),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(_imagePickerCancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );

    onChooseAction(result);
  }

  static void _presentMaterialBottomSheet(
    BuildContext context,
    Function(ImagePickerAction? source) onChooseAction,
  ) async {
    var result = await showModalBottomSheet<ImagePickerAction>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_enhance),
                  title: Text(_imagePickerCamera),
                  onTap: () =>
                      Navigator.of(context).pop(ImagePickerAction.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(_imagePickerGallery),
                  onTap: () =>
                      Navigator.of(context).pop(ImagePickerAction.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    onChooseAction(result);
  }
}
