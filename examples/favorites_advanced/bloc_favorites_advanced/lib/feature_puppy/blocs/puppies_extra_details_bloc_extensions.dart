// part of 'puppies_extra_details_bloc.dart';

// extension _StreamFetchExtraDetails on List<Puppy> {
  /// Fetch extra details in a chunks collected by 100 milliseconds buffer
  /// and fetch them (if needed) at once.

  // List<Puppy> fetchExtraDetails(
  //   PuppiesRepository repository,
  // ) =>


// Collect puppies in 100 milliseconds buckets
// bufferTime(const Duration(milliseconds: 100))
// Get the puppies that still have no extra details.
// map((puppies) => puppies.whereNoExtraDetails())
// Only execute API call if needed.
// .where((puppies) => puppies.isNotEmpty)
// Get all extra details from the API
// .flatMap(
//     (value) => repository.fetchFullEntities(value.ids).asStream());
// }
