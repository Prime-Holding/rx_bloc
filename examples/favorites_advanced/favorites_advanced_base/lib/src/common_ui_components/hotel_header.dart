import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../core.dart';
import '../../models.dart';

class HotelHeader extends StatelessWidget {
  const HotelHeader({
    Key? key,
    required this.hotel,
    required EdgeInsets? padding,
  })  : _padding = padding,
        super(key: key);

  final Hotel hotel;
  final EdgeInsets? _padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      hotel.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: _padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: SkeletonText(
                              text: hotel.displaySubtitle,
                              height: 17,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (hotel.displayDist != null)
                            Icon(
                              FontAwesomeIcons.mapMarkerAlt,
                              size: 12,
                              color:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                            ),
                          const SizedBox(width: 4),
                          Expanded(
                            flex: 2,
                            child: SkeletonText(
                              text: hotel.displayDist == null
                                  ? null
                                  : '${hotel.displayDist!.toStringAsFixed(1)} km to city',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.8)),
                              height: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: <Widget>[
                          if (hotel.displayRating != null)
                            SmoothStarRating(
                              allowHalfRating: true,
                              starCount: 5,
                              rating: hotel.extraDetails?.rating ?? 0.0,
                              size: 20,
                              color:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                              borderColor:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                            ),
                          Expanded(
                            child: SkeletonText(
                              text: hotel.displayReviews == null
                                  ? null
                                  : ' ${hotel.displayReviews!} Reviews',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                              height: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '\$${hotel.perNight}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                Text(
                  '/per night',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
