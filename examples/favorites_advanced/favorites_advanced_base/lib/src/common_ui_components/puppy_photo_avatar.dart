import 'dart:io';

import 'package:flutter/material.dart';

class PuppyAvatar extends StatelessWidget {
  PuppyAvatar({
    required this.asset,
    this.radius,
  });

  final String asset;
  final double? radius;

  double get _imageRadius => radius ?? 108;

  @override
  Widget build(BuildContext context) => ClipOval(
        child: asset.contains('assets/puppie_')
            ? Image.asset(
                asset,
                width: _imageRadius,
                height: _imageRadius,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(asset),
                width: _imageRadius,
                height: _imageRadius,
                fit: BoxFit.cover,
              ),
      );
}
