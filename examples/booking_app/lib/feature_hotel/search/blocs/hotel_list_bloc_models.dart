part of 'hotel_list_bloc.dart';

class _ReloadData {
  _ReloadData({
    required this.reset,
    required this.filters,
    this.fullReset = false,
  });

  final bool reset;
  final bool fullReset;
  final HotelSearchFilters filters;

  @override
  bool operator ==(Object other) {
    if (other is _ReloadData) {
      return reset == other.reset &&
          filters.query == other.filters.query &&
          fullReset == other.fullReset;
    }

    return false;
  }

  @override
  String toString() =>
      '{reset: $reset, fullReset: $fullReset, query: ${filters.query}}';

  @override
  int get hashCode =>
      reset.hashCode ^ fullReset.hashCode ^ filters.query.hashCode;
}
