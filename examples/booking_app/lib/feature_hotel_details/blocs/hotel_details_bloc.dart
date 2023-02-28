import 'package:collection/collection.dart' show IterableExtension;
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';
import '../../base/common_blocs/hotels_extra_details_bloc.dart';
import '../../base/services/hotels_service.dart';

part 'hotel_details_bloc.rxb.g.dart';
part 'hotel_details_bloc_extensions.dart';

abstract class HotelDetailsBlocEvents {}

abstract class HotelDetailsBlocStates {
  Stream<Hotel> get hotel;
}

@RxBloc()
class HotelDetailsBloc extends $HotelDetailsBloc {
  HotelDetailsBloc(
    CoordinatorBlocType coordinatorBloc,
    HotelsExtraDetailsBlocType hotelsExtraDetailsBlocType,
    HotelsService hotelsService, {
    required String hotelId,
    Hotel? hotel,
  })  : _hotel = hotel,
        _hotelId = hotelId,
        _coordinatorBlocType = coordinatorBloc,
        _hotelsExtraDetailsBlocType = hotelsExtraDetailsBlocType,
        _hotelsService = hotelsService;

  final Hotel? _hotel;
  final String _hotelId;

  final CoordinatorBlocType _coordinatorBlocType;
  final HotelsExtraDetailsBlocType _hotelsExtraDetailsBlocType;
  final HotelsService _hotelsService;

  //get the latest updated version of the hotel
  @override
  Stream<Hotel> _mapToHotelState() => Rx.merge([
        _getHotelIfNeeded().asStream().doOnData(
              (hotel) => _hotelsExtraDetailsBlocType.events.fetchExtraDetails(
                hotel,
                allProps: true,
              ),
            ),
        _coordinatorBlocType.onHotelUpdated(_hotelId),
      ]).shareReplay(maxSize: 1);

  Future<Hotel> _getHotelIfNeeded() async =>
      _hotel != null ? _hotel! : await _hotelsService.hotelById(_hotelId);
}
