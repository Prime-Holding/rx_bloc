import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';

class FiltersBar extends StatelessWidget {
  FiltersBar({
    this.onDatePressed,
    this.onHotelDetailsPressed,
    this.onDateRangeFilterClearPressed,
    this.onAdvancedFilterClearPressed,
    this.dateRangeFilterClearEnabled = false,
    this.advancedFilerClearEnabled = false,
    this.dateRangeText = '',
    this.advancedFiltersText = '',
  });

  final VoidCallback? onDatePressed;
  final VoidCallback? onHotelDetailsPressed;
  final VoidCallback? onDateRangeFilterClearPressed;
  final VoidCallback? onAdvancedFilterClearPressed;

  final bool dateRangeFilterClearEnabled;
  final bool advancedFilerClearEnabled;

  final String dateRangeText;
  final String advancedFiltersText;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FocusButton(
                      onPressed: () {
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
                    if (dateRangeFilterClearEnabled)
                      _buildClearButton(onDateRangeFilterClearPressed),
                  ],
                ),
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
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FocusButton(
                      onPressed: () {
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
                    if (advancedFilerClearEnabled)
                      _buildClearButton(onAdvancedFilterClearPressed),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildClearButton(VoidCallback? onPressed) => FocusButton(
        onPressed: onPressed ?? () {},
        child: const Icon(Icons.cancel, color: Colors.blue),
      );
}
