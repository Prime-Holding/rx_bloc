import 'package:flutter/material.dart';

class DateRangeFilterData {
  DateRangeFilterData({
    required this.dateRange,
    required this.text,
  });

  final DateTimeRange? dateRange;
  final String text;
}
