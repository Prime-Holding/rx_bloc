import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models.dart';

class HotelImage extends StatelessWidget {
  const HotelImage({
    Key? key,
    required double aspectRatio,
    required this.hotel,
  })  : _aspectRatio = aspectRatio,
        super(key: key);

  final double _aspectRatio;
  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'HotelImage${hotel.id}',
      child: AspectRatio(
        aspectRatio: _aspectRatio,
        child: Image.network(
          hotel.image,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return LoadingWidget();
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return Icon(Icons.error);
          },
        ),
      ),
    );
  }
}
