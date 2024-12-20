import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/keys.dart' as keys;
import 'package:favorites_advanced_base/src/theme/hotel_app_theme.dart';
import 'package:flutter/material.dart';

import 'hotel_header.dart';
import 'hotel_image.dart';

typedef OnFavorite = Function(Hotel hotel, bool isFavorite);
typedef OnCardPressed = Function(Hotel hotel);

class HotelListItem extends StatelessWidget {
  final Hotel hotel;
  final OnFavorite _onFavorite;
  final Function(Hotel hotel) _onCardPressed;

  const HotelListItem({
    required this.hotel,
    required OnFavorite onFavorite,
    required OnCardPressed onCardPressed,
    EdgeInsets? padding,
    double aspectRatio = 2,
    Key? key,
  })  : _onFavorite = onFavorite,
        _onCardPressed = onCardPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        key: key ?? keys.listItemById(hotel.id),
        child: InkWell(
          key: keys.listItemTapById(hotel.id),
          onTap: () => _onCardPressed(hotel),
          child: HotelCard(
            hotel: hotel,
            onFavorite: _onFavorite,
            padding: EdgeInsets.only(top: 4),
          ),
        ),
      );
}

class HotelCard extends StatelessWidget {
  const HotelCard({
    Key? key,
    required this.hotel,
    double aspectRatio = 2,
    EdgeInsets? padding,
    OnFavorite? onFavorite,
  })  : _onFavorite = onFavorite,
        _aspectRatio = aspectRatio,
        _padding = padding,
        super(key: key);

  final Hotel hotel;
  final OnFavorite? _onFavorite;
  final double _aspectRatio;
  final EdgeInsets? _padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              HotelImage(aspectRatio: _aspectRatio, hotel: hotel),
              HotelHeader(hotel: hotel, padding: _padding),
            ],
          ),
          if (_onFavorite != null)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: keys.favoriteButtonById(hotel.id),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () => _onFavorite!.call(hotel, !hotel.isFavorite),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      hotel.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: HotelAppTheme.buildLightTheme().primaryColor,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
