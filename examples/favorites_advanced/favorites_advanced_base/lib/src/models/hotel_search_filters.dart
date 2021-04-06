import 'package:flutter/material.dart';

class HotelSearchFilters {
  HotelSearchFilters({
    this.query = '',
    this.dateRange,
    this.roomCapacity = 0,
    this.personCapacity = 0,
  });

  final int roomCapacity;
  final int personCapacity;
  final String query;
  final DateTimeRange? dateRange;

  bool get advancedFiltersOn =>
      dateRange != null || roomCapacity > 0 || personCapacity > 0;
}
