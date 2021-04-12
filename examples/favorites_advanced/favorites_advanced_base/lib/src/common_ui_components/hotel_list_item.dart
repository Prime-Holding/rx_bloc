import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core.dart';
import 'hotel_header.dart';
import 'hotel_image.dart';

typedef OnFavorite = Function(Hotel hotel, bool isFavorite);
typedef OnVisible = Function(Hotel hotel);
typedef OnCardPressed = Function(Hotel hotel);

class HotelListItem extends StatelessWidget {
  final Hotel hotel;
  final OnFavorite _onFavorite;
  final Function(Hotel hotel)? _onVisible;
  final Function(Hotel hotel) _onCardPressed;

  const HotelListItem({
    required this.hotel,
    required OnFavorite onFavorite,
    required OnCardPressed onCardPressed,
    EdgeInsets? padding,
    double aspectRatio = 2,
    OnVisible? onVisible,
    Key? key,
  })  : _onFavorite = onFavorite,
        _onVisible = onVisible,
        _onCardPressed = onCardPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) => _onVisible == null
      ? _buildCard()
      : VisibilityDetector(
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0.7) {
              _onVisible!(hotel);
            }
          },
          key: Key("VisiblePuppyCard${hotel.id}"),
          child: _buildCard(),
        );

  Widget _buildCard() {
    return Material(
      child: InkWell(
        onTap: () => _onCardPressed(hotel),
        child: HotelCard(
          hotel: hotel,
          onFavorite: _onFavorite,
          padding: EdgeInsets.only(top: 4),
        ),
      ),
    );
  }
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () => _onFavorite!.call(hotel, !hotel.isFavorite),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      hotel.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: DesignSystem.of(context).colors.primaryColor,
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
