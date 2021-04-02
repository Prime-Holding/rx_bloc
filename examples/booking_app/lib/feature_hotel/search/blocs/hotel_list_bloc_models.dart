part of 'hotel_list_bloc.dart';

class _ReloadData {
  _ReloadData({
    required this.reset,
    required this.query,
    this.fullReset = false,
  });

  final bool reset;
  final bool fullReset;
  final String query;

  @override
  bool operator ==(Object other) {
    if (other is _ReloadData) {
      return reset == other.reset &&
          query == other.query &&
          fullReset == other.fullReset;
    }

    return false;
  }

  @override
  String toString() => '{reset: $reset, fullReset: $fullReset, query: $query}';

  @override
  int get hashCode => reset.hashCode ^ fullReset.hashCode ^ query.hashCode;
}
