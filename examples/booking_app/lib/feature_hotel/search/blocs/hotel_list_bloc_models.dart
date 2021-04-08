part of 'hotel_list_bloc.dart';

class _ReloadData with EquatableMixin {
  _ReloadData({
    required this.reset,
    required this.filters,
    this.fullReset = false,
  });

  factory _ReloadData.withInitial() => _ReloadData(
        reset: true,
        filters: HotelSearchFilters(),
        fullReset: true,
      );

  final bool reset;
  final bool fullReset;
  final HotelSearchFilters filters;

  @override
  List<Object?> get props => [reset, filters, fullReset];
}
