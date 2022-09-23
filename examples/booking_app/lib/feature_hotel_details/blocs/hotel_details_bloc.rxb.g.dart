// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'hotel_details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class HotelDetailsBlocType extends RxBlocTypeBase {
  HotelDetailsEvents get events;
  HotelDetailsStates get states;
}

/// [$HotelDetailsBloc] extended by the [HotelDetailsBloc]
/// {@nodoc}
abstract class $HotelDetailsBloc extends RxBlocBase
    implements HotelDetailsEvents, HotelDetailsStates, HotelDetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// The state of [imagePath] implemented in [_mapToImagePathState]
  late final Stream<String> _imagePathState = _mapToImagePathState();

  /// The state of [title] implemented in [_mapToTitleState]
  late final Stream<String> _titleState = _mapToTitleState();

  /// The state of [subTitle] implemented in [_mapToSubTitleState]
  late final Stream<String?> _subTitleState = _mapToSubTitleState();

  /// The state of [rating] implemented in [_mapToRatingState]
  late final Stream<String> _ratingState = _mapToRatingState();

  /// The state of [isFavourite] implemented in [_mapToIsFavouriteState]
  late final Stream<bool> _isFavouriteState = _mapToIsFavouriteState();

  /// The state of [hotel] implemented in [_mapToHotelState]
  late final Stream<Hotel> _hotelState = _mapToHotelState();

  @override
  Stream<String> get imagePath => _imagePathState;

  @override
  Stream<String> get title => _titleState;

  @override
  Stream<String?> get subTitle => _subTitleState;

  @override
  Stream<String> get rating => _ratingState;

  @override
  Stream<bool> get isFavourite => _isFavouriteState;

  @override
  Stream<Hotel> get hotel => _hotelState;

  Stream<String> _mapToImagePathState();

  Stream<String> _mapToTitleState();

  Stream<String?> _mapToSubTitleState();

  Stream<String> _mapToRatingState();

  Stream<bool> _mapToIsFavouriteState();

  Stream<Hotel> _mapToHotelState();

  @override
  HotelDetailsEvents get events => this;

  @override
  HotelDetailsStates get states => this;

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
