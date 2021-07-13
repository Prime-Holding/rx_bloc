import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'hotel_details_bloc.rxb.g.dart';
part 'hotel_details_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class HotelDetailsEvents {
  void fetchFullExtraDetails(Hotel hotel);
}

abstract class HotelDetailsStates {
  Stream<String> get imagePath;

  Stream<String> get title;

  Stream<String?> get subTitle;

  Stream<String> get rating;

  Stream<bool> get isFavourite;

  Stream<Hotel> get hotel;
}

@RxBloc()
class HotelDetailsBloc extends $HotelDetailsBloc {
  HotelDetailsBloc(
    PaginatedHotelsRepository hotelsRepository, {
    required Hotel hotel,
  })  : _hotel = hotel,
        _hotelsRepository = hotelsRepository;

  final Hotel _hotel;

  final PaginatedHotelsRepository _hotelsRepository;
  //get the latest updated version of the hotel
  @override
  Stream<Hotel> _mapToHotelState() =>
      _$fetchFullExtraDetailsEvent.startWith(_hotel).asyncMap((hotel) async {
        final fullExtraDetails =
            await _hotelsRepository.fetchFullExtraDetails(hotel.id);
        hotel = hotel.copyWith(fullExtraDetails: fullExtraDetails);
        if (hotel.extraDetails == null) {
          final extraDetails =
              await _hotelsRepository.fetchExtraDetails([hotel.id]);
          hotel = hotel.copyWith(extraDetails: extraDetails.first);
        }
        return hotel;
      }).shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToImagePathState() => hotel.mapToImagePath();

  @override
  Stream<bool> _mapToIsFavouriteState() => hotel.mapToIsFavorite();

  @override
  Stream<String> _mapToRatingState() => hotel.mapToRating();

  @override
  Stream<String?> _mapToSubTitleState() => hotel.mapToSubTitle();

  @override
  Stream<String> _mapToTitleState() => hotel.mapToTitle();
}
