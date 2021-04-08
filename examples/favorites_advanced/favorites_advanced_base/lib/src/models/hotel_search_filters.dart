import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/src/utils/enums.dart';
import 'package:flutter/material.dart';

class HotelSearchFilters with EquatableMixin {
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

  @override
  List<Object?> get props =>
      [query, dateRange, roomCapacity, personCapacity, sortBy];
}
