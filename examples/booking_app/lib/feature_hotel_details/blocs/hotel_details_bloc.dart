import 'package:collection/collection.dart' show IterableExtension;
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';

part 'hotel_details_bloc.rxb.g.dart';
part 'hotel_details_bloc_extensions.dart';

abstract class HotelDetailsBlocEvents {}

abstract class HotelDetailsBlocStates {
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
}
