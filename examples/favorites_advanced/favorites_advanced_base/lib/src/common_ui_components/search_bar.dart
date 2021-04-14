import 'package:flutter/material.dart';

import '../../core.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
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
                    color: DesignSystem.of(context).colors.secondaryColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(38.0),
                    ),
                    boxShadow: DesignSystem.of(context).colors.brightness ==
                            Brightness.light
                        ? <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(0, 2),
                                blurRadius: 8.0),
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 4, bottom: 4),
                    child: TextField(
                      controller: controller,
                      style: DesignSystem.of(context).typography.headline3,
                      cursorColor: DesignSystem.of(context).colors.primaryColor,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Dubai...',
                          hintStyle:
                              DesignSystem.of(context).typography.headline3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
