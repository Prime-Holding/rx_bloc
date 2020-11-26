part of 'puppy_manage_bloc.dart';

extension _PuppyUpdate on Stream<_MarkAsFavoriteEventArgs> {
  /// Mark the puppy as favorite as emitting an event with the updated puppy
  /// immediately, so that the listeners can update accordingly.
  ///
  /// Then send the request to the API and in case of success emits the updated
  /// puppy, otherwise emit an event with the origin puppy.
  ///
  /// `Side effect`: once the puppy gets updated emmit an event to
  /// [CoordinatorBloc]
  Stream<Puppy> markPuppyAsFavorite(
    PuppiesRepository puppiesRepository,
    PuppyManageBloc bloc,
    CoordinatorBlocType coordinatorBloc,
  ) =>
      throttleTime(const Duration(milliseconds: 200))
          .switchMap<Result<Puppy>>((args) async* {
            yield Result.loading();
            yield Result.success(
                args.puppy.copyWith(isFavorite: args.isFavorite));

            yield Result.loading();
            try {
              yield Result.success((await puppiesRepository
                      .favoritePuppy(args.puppy, isFavorite: args.isFavorite))
                  .copyWith(
                      displayBreedCharacteristics:
                          args.puppy.displayBreedCharacteristics,
                      displayName: args.puppy.displayName));
            } catch (e) {
              bloc._favoritePuppyError.sink.add(e);
              yield Result.success(args.puppy);
            }
          })
          .setResultStateHandler(bloc)
          .whereSuccess()
          .doOnData((puppy) => coordinatorBloc.events.puppyUpdated(puppy));
}
