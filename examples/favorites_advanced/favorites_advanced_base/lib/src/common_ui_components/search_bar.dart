import 'package:favorites_advanced_base/src/theme/hotel_app_theme.dart';
import 'package:flutter/material.dart';

import '../resources/keys.dart' as keys;

class HotelSearchBar extends StatelessWidget {
  const HotelSearchBar({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 16, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: HotelAppTheme.buildLightTheme().colorScheme.surface,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(38.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 8.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 4, bottom: 4),
                    child: TextField(
                      key: keys.searchFieldKey,
                      controller: controller,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Dubai...',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
