part of 'puppy_list_bloc.dart';

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
  String toString() => '{reset: $reset, fullReset: $fullReset, query: $query}';
}
