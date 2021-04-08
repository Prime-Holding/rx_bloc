import 'dart:async';

import 'package:favorites_advanced_base/models.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'coordinator_bloc.rxb.g.dart';

// ignore: one_member_abstracts
abstract class CoordinatorEvents {
  void hotelUpdated(Hotel hotel);

  void hotelsWithExtraDetailsFetched(List<Hotel> hotels);
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<Hotel> get onHotelUpdated;

  @RxBlocIgnoreState()
  Stream<List<Hotel>> get onFetchedHotelsWithExtraDetails;

  Stream<List<Hotel>> get onHotelsUpdated;
}

/// The coordinator bloc manages the communication between blocs.
///
/// The goals is to keep all blocs decoupled from each other
/// as the entire communication flow goes through this bloc.
/// This way we ensure that we don't introduce a dependency hell.
@RxBloc()
class CoordinatorBloc extends $CoordinatorBloc {
  @override
  Stream<Hotel> get onHotelUpdated => _$hotelUpdatedEvent;

  @override
  Stream<List<Hotel>> get onFetchedHotelsWithExtraDetails =>
      _$hotelsWithExtraDetailsFetchedEvent;

  @override
  Stream<List<Hotel>> _mapToOnHotelsUpdatedState() => Rx.merge([
        states.onHotelUpdated.map((hotel) => [hotel]),
        states.onFetchedHotelsWithExtraDetails
      ]).share();
}
