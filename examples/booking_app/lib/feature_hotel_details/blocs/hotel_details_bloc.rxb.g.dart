// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'hotel_details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class HotelDetailsBlocType extends RxBlocTypeBase {
  HotelDetailsBlocEvents get events;
  HotelDetailsBlocStates get states;
}

/// [$HotelDetailsBloc] extended by the [HotelDetailsBloc]
/// {@nodoc}
abstract class $HotelDetailsBloc extends RxBlocBase
    implements
        HotelDetailsBlocEvents,
        HotelDetailsBlocStates,
        HotelDetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// The state of [hotel] implemented in [_mapToHotelState]
  late final Stream<Hotel> _hotelState = _mapToHotelState();

  @override
  Stream<Hotel> get hotel => _hotelState;

  Stream<Hotel> _mapToHotelState();

  @override
  HotelDetailsBlocEvents get events => this;

  @override
  HotelDetailsBlocStates get states => this;

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
