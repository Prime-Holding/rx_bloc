part of 'puppies_extra_details_bloc.dart';

extension _StreamFetchExtraDetails on Stream<Puppy> {
  /// Fetch extra details in a chunks collected by 100 milliseconds buffer
  /// and fetch them (if needed) at once.
  ///
  /// `Side effect`: Emmits an event to [CoordinatorBloc]
  /// once the details are fetched.
  Stream<List<Puppy>> fetchExtraDetails(
    PaginatedPuppiesRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) =>
      // Collect puppies in 100 milliseconds buckets
      bufferTime(const Duration(milliseconds: 100))
          // Get the puppies that still have no extra details.
          .map((puppies) => puppies.whereNoExtraDetails())
          // Only execute API call if needed.
          .where((puppies) => puppies.isNotEmpty)
          // Get all extra details from the API
          .flatMap(
              (value) => repository.fetchFullEntities(value.ids).asStream())
          // Notify the coordination BloC
          .doOnData(
            (puppies) =>
                coordinatorBloc.events.puppiesWithExtraDetailsFetched(puppies),
          );
}
