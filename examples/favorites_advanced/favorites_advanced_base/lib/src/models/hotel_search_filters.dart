import 'package:favorites_advanced_base/src/utils/enums.dart';
import 'package:flutter/material.dart';

class HotelSearchFilters {
  HotelSearchFilters({
    this.query = '',
    this.dateRange,
    this.roomCapacity = 0,
    this.personCapacity = 0,
    this.sortBy = SortBy.none,
  });

  final int roomCapacity;
  final int personCapacity;
  final String query;
  final DateTimeRange? dateRange;
  final SortBy sortBy;

  bool get advancedFiltersOn =>
      dateRange != null || roomCapacity > 0 || personCapacity > 0;
}
