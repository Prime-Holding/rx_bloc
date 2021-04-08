import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DateRangeFilterData with EquatableMixin {
  DateRangeFilterData({
    required this.dateRange,
    required this.text,
  });

  final DateTimeRange? dateRange;
  final String text;

  @override
  List<Object?> get props => [dateRange, text];
}
