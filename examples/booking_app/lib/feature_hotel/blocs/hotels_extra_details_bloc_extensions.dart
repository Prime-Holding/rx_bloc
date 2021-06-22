part of 'hotels_extra_details_bloc.dart';

extension _StreamFetchExtraDetails on Stream<_FetchExtraDetailsEventArgs> {
  /// Fetch extra details in a chunks collected by 100 milliseconds buffer
  /// and fetch them (if needed) at once.
  ///
  /// `Side effect`: Emmits an event to [CoordinatorBloc]
  /// once the details are fetched.
  Stream<List<Hotel>> fetchExtraDetails(
    PaginatedHotelsRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) =>
      // Collect hotels in 100 milliseconds buckets
      bufferTime(const Duration(milliseconds: 100))
          // Make sure there is at least one entity
          .where((args) => args.isNotEmpty)
          // Get the hotels that still have no extra details.
          .map(
            (hotelArgs) => _HotelsContainer(
              allProps: hotelArgs.first.allProps,
              hotels: hotelArgs.whereNoExtraDetails(
                allProps: hotelArgs.first.allProps,
              ),
            ),
          )
          // Only execute API call if needed.
          .where((container) => container.hotels.isNotEmpty)
          // Get all extra details from the API
          .asyncMap(
        (value) async {
          final extraDetails =
              await repository.fetchExtraDetails(value.hotels.ids);
          return value.hotels.mergeWithExtraDetails(extraDetails);
        },
      )
          // Notify the coordination BloC
          .doOnData(
        (hotels) =>
            coordinatorBloc.events.hotelsWithExtraDetailsFetched(hotels),
      );
}

class _HotelsContainer {
  _HotelsContainer({
    required this.hotels,
    required this.allProps,
  });

  final List<Hotel> hotels;
  final bool allProps;
}

extension _FetchExtraDetailsEventArgsUtils
    on List<_FetchExtraDetailsEventArgs> {
  List<Hotel> whereNoExtraDetails({required bool allProps}) {
    final hotels = map((args) => args.hotel).toList();
    return allProps
        ? hotels.whereNoFullExtraDetails()
        : hotels.whereNoExtraDetails();
  }
}

extension _MergeExtraDetails on List<Hotel> {
  List<Hotel> mergeWithExtraDetails(List<HotelExtraDetails> extraDetails) =>
      map((hotel) {
        final extras = extraDetails.firstWhereOrNull(
          (extraDetails) => extraDetails.hotelId.contains(hotel.id),
        );
        return hotel.copyWith(
          extraDetails: extras,
        );
      }).toList();
}
