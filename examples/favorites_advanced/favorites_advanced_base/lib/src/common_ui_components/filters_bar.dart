import 'package:flutter/material.dart';

class FiltersBar extends StatelessWidget {
  FiltersBar({
    this.onDatePressed,
    this.onHotelDetailsPressed,
    this.dateRangeText = '',
    this.advancedFiltersText = '',
  });

  final VoidCallback? onDatePressed;
  final VoidCallback? onHotelDetailsPressed;

  final String dateRangeText;
  final String advancedFiltersText;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 18, bottom: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        onDatePressed?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Choose date',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              dateRangeText,
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
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
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 1,
                height: 42,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        onHotelDetailsPressed?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Advanced filters',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              advancedFiltersText,
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
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
          ],
        ),
      );
}
