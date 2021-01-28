part of 'favorite_puppies_bloc.dart';

extension _ResultPuppies on Stream<Result<List<Puppy>>> {
  /// Map the successfully fetched puppies to the length of the list.
  ReplayStream<int> mapToCount() =>
      whereSuccess().map((puppies) => puppies.length).shareReplay(maxSize: 1);
}

extension _PuppiesFecher on Stream<bool> {
  /// Fetch puppies as applying a back pressure of 200 milliseconds.
  Stream<Result<List<Puppy>>> fetchPuppies(PuppiesRepository repository) =>
      throttleTime(const Duration(milliseconds: 200)).switchMap(
        (silently) => repository
            .getFavoritePuppies()
            .asResultStream()
            // just skip the loading event
            .skip(silently ? 1 : 0),
      );
}

extension _StreamBindToPuppies on Stream<List<Puppy>> {
  /// Update the given [puppiesToUpdate] based on the [Puppy.isFavorite] flag
  /// of the stream events.
  ///
  /// If the [Puppy.isFavorite] of the puppies is [true] the entity will be
  /// removed from [puppiesToUpdate], otherwise will be added.
  StreamSubscription<Result<List<Puppy>>> updateFavoritePuppies(
    BehaviorSubject<Result<List<Puppy>>> puppiesToUpdate,
  ) =>
      map((puppies) {
        final puppiesResult = puppiesToUpdate.value;

        if (puppiesResult is ResultSuccess<List<Puppy>>) {
          return Result.success(puppiesResult.data.manageFavoriteList(puppies));
        }

        return puppiesResult;
      }).bind(puppiesToUpdate);
}
