part of 'favorite_hotels_bloc.dart';

extension _ResultHotels on Stream<Result<List<Hotel>>> {
  /// Map the successfully fetched hotels to the length of the list.
  ReplayStream<int> mapToCount() =>
      whereSuccess().map((hotels) => hotels.length).shareReplay(maxSize: 1);
}

extension _HotelsFecher on Stream<bool> {
  /// Fetch hotels as applying a back pressure of 200 milliseconds.
  Stream<Result<List<Hotel>>> fetchHotels(HotelsRepository repository) =>
      throttleTime(const Duration(milliseconds: 200)).switchMap(
        (silently) => repository
            .getFavoriteHotels()
            .asResultStream()
            // just skip the loading event
            .skip(silently ? 1 : 0),
      );
}

extension _StreamBindToHotels on Stream<List<Hotel>> {
  /// Update the given [hotelsToUpdate] based on the [Hotel.isFavorite] flag
  /// of the stream events.
  ///
  /// If the [Hotel.isFavorite] of the hotels is [true] the entity will be
  /// removed from [hotelsToUpdate], otherwise will be added.
  StreamSubscription<Result<List<Hotel>>> updateFavoriteHotels(
    BehaviorSubject<Result<List<Hotel>>> hotelsToUpdate,
  ) =>
      map((hotels) {
        final hotelsResult = hotelsToUpdate.value ?? Result.success([]);

        if (hotelsResult is ResultSuccess<List<Hotel>>) {
          return Result.success(hotelsResult.data.manageFavoriteList(hotels));
        }

        return hotelsResult;
      }).bind(hotelsToUpdate);
}
