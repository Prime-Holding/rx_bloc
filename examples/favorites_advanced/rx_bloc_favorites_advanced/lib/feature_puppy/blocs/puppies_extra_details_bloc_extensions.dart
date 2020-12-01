part of 'puppies_extra_details_bloc.dart';

extension _StreamFetchExtraDetails on Stream<Puppy> {
  /// Fetch extra details in a chunks collected by 100 milliseconds buffer
  /// and fetch them (if needed) at once.
  ///
  /// `Side effect`: Emmits an event to [CoordinatorBloc]
  /// once the details are fetched.
  Stream<List<Puppy>> fetchExtraDetails(
    PuppiesRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) =>
      bufferTime(const Duration(milliseconds: 100))
          .map((puppies) => puppies.whereNoExtraDetails())
          .where((puppies) => puppies.isNotEmpty)
          .flatMap(
              (value) => repository.fetchFullEntities(value.ids).asStream())
          .doOnData(
            (puppies) =>
                coordinatorBloc.events.puppiesWithExtraDetailsFetched(puppies),
          );
}
