import 'package:flutter/widgets.dart';

import '../../models.dart';

class HotelImage extends StatelessWidget {
  const HotelImage({
    Key? key,
    required double aspectRatio,
    required this.hotel,
  })   : _aspectRatio = aspectRatio,
        super(key: key);

  final double _aspectRatio;
  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: Image.asset(
        hotel.imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
