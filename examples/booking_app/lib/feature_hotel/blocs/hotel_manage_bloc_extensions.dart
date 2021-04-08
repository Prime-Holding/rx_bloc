part of 'hotel_manage_bloc.dart';

extension _HotelUpdate on Stream<_MarkAsFavoriteEventArgs> {
  /// Mark the hotel as favorite as emitting an event with the updated hotel
  /// immediately, so that the listeners can update accordingly.
  ///
  /// Then send the request to the API and in case of success emits the updated
  /// hotel, otherwise emit an event with the origin hotel.
  ///
  /// `Side effect`: once the hotel gets updated emmit an event to
  /// [CoordinatorBloc]
  Stream<Hotel> markHotelAsFavorite(
    PaginatedHotelsRepository hotelsRepository,
    HotelManageBloc bloc,
  ) =>
      throttleTime(const Duration(milliseconds: 200))
          .switchMap<Result<Hotel>>((args) async* {
            yield Result.loading();
            // emit an event with the copied instance of the entity, so that UI
            // can update immediately
            yield Result.success(
              args.hotel.copyWith(isFavorite: args.isFavorite),
            );

            yield Result.loading();
            try {
              final updatedHotel = await hotelsRepository
                  .favoriteHotel(args.hotel, isFavorite: args.isFavorite);

              yield Result.success(updatedHotel.copyWith(
                displayDist: args.hotel.displayDist,
                displaySubtitle: args.hotel.displaySubtitle,
                displayRating: args.hotel.displayRating,
                displayReviews: args.hotel.displayReviews,
                displayFeatures: args.hotel.displayFeatures,
                displayDescription: args.hotel.displayDescription,
              ));
            } on Exception catch (e) {
              // In case of any error rollback the hotel to the previous state
              // and notify the UI layer for the error
              bloc._favoriteHotelError.sink.add(e);
              yield Result.success(args.hotel);
            }
          })
          .setResultStateHandler(bloc)
          .whereSuccess();
}

extension _ExceptionExtensions on Stream<Exception> {
  Stream<String> mapToString() =>
      map((e) => e.toString().replaceAll('Exception: ', ''));
}
