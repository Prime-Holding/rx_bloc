import 'package:booking_app/feature_hotel/search/blocs/hotel_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

class FilterBar extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(0, -2),
                      blurRadius: 8.0),
                ],
              ),
            ),
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RxBlocBuilder<HotelListBlocType, String>(
                        state: (bloc) => bloc.states.hotelsFound,
                        builder: (context, snapshot, bloc) => Text(
                          snapshot.data ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.grey.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      onTap: () {
                        // FocusScope.of(context).requestFocus(FocusNode());
                        // Navigator.push<dynamic>(
                        //   context,
                        //   MaterialPageRoute<dynamic>(
                        //       builder: (BuildContext context) =>
                        //           FiltersScreen(),
                        //       fullscreenDialog: true),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.sort,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Divider(
              height: 1,
            ),
          )
        ],
      );
}
