import 'package:flutter/material.dart';

class HotelSearchFilters {
  HotelSearchFilters({
    this.query = '',
    this.dateRange,
  });

  final String query;
  final DateTimeRange? dateRange;

  bool get advancedFiltersOn => dateRange != null;
}
