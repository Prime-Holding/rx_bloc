part of 'hotel_list_bloc.dart';

class _ReloadData {
  _ReloadData({
    required this.reset,
    required this.query,
    this.dateRange,
    this.fullReset = false,
  });

  final bool reset;
  final bool fullReset;
  final String query;
  final DateTimeRange? dateRange;

  @override
  String toString() => '{reset: $reset, fullReset: $fullReset, query: $query}';
}
