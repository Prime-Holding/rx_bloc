part of 'hotels_extra_details_bloc.dart';

extension _StreamFetchExtraDetails on Stream<Hotel> {
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
          // Get the hotels that still have no extra details.
          .map((hotels) => hotels.whereNoExtraDetails())
          // Only execute API call if needed.
          .where((hotels) => hotels.isNotEmpty)
          // Get all extra details from the API
          .flatMap(
              (value) => repository.fetchFullEntities(value.ids).asStream())
          // Notify the coordination BloC
          .doOnData(
            (hotels) =>
                coordinatorBloc.events.hotelsWithExtraDetailsFetched(hotels),
          );
}
