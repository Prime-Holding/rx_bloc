part of 'puppy_list_bloc.dart';

extension _ReloadDataFetcher on Stream<_ReloadData> {
  /// Fetch the puppies based on the [_ReloadData.query] as applying
  /// a back pressure of 200 milliseconds.
  ///
  /// In case [_ReloadData.silently] is true, the loading event will be skipped.
  Stream<Result<List<Puppy>>> fetchPuppies(PuppiesRepository repository) =>
      debounceTime(const Duration(milliseconds: 600)).switchMap(
        (reloadData) => repository
            .getPuppies(query: reloadData.query)
            .asResultStream()
            // skip the loading event if silently is true
            .skip(reloadData.silently ? 1 : 0),
      );
}

extension StreamBindToPuppies on Stream<List<Puppy>> {
  /// Update the given [puppiesToUpdate] based on the list of puppies emitted
  /// in the current stream.
  ///
  /// For more information check [ListPuppyUtils.mergeWith].
  StreamSubscription<Result<List<Puppy>>> updatePuppies(
          BehaviorSubject<Result<List<Puppy>>> puppiesToUpdate) =>
      map((puppies) {
        final puppiesResult = puppiesToUpdate.value;

        if (puppiesResult is ResultSuccess<List<Puppy>>) {
          return Result.success(puppiesResult.data.mergeWith(puppies));
        }

        return puppiesResult;
      }).bind(puppiesToUpdate);
}

extension _PuppyListBlocReloaders on PuppyListBloc {
  /// Use [filterPuppies] and [reloadFavoritePuppies] as
  /// a reload trigger.
  Stream<_ReloadData> _reloadTrigger() => Rx.merge([
        _$filterPuppiesEvent.distinct().map(
              (query) => _ReloadData(
                silently: false,
                query: query,
              ),
            ),
        _$reloadFavoritePuppiesEvent.map(
          (silently) => _ReloadData(
            silently: silently,
            query: _$filterPuppiesEvent.value,
          ),
        ),
      ]);
}
