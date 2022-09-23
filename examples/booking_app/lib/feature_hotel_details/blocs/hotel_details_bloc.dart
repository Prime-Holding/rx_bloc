import 'package:collection/collection.dart' show IterableExtension;
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';

part 'hotel_details_bloc.rxb.g.dart';
part 'hotel_details_bloc_extensions.dart';

abstract class HotelDetailsEvents {}

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
    CoordinatorBlocType coordinatorBloc, {
    required Hotel hotel,
  })  : _hotel = hotel,
        _coordinatorBlocType = coordinatorBloc;

  final Hotel _hotel;

  final CoordinatorBlocType _coordinatorBlocType;

  //get the latest updated version of the hotel
  @override
  Stream<Hotel> _mapToHotelState() => _coordinatorBlocType
      .onHotelUpdated(_hotel)
      .startWith(_hotel)
      .shareReplay(maxSize: 1);

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
