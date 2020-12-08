// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppies_extra_details_bloc.dart';

/// PuppiesExtraDetailsBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class PuppiesExtraDetailsBlocType extends RxBlocTypeBase {
  PuppiesExtraDetailsEvents get events;

  PuppiesExtraDetailsStates get states;
}

/// $PuppiesExtraDetailsBloc class - extended by the PuppiesExtraDetailsBloc bloc
/// {@nodoc}
abstract class $PuppiesExtraDetailsBloc extends RxBlocBase
    implements
        PuppiesExtraDetailsEvents,
        PuppiesExtraDetailsStates,
        PuppiesExtraDetailsBlocType {
  ///region Events

  ///region fetchExtraDetails

  final _$fetchExtraDetailsEvent = PublishSubject<Puppy>();
  @override
  void fetchExtraDetails(Puppy puppy) => _$fetchExtraDetailsEvent.add(puppy);

  ///endregion fetchExtraDetails

  ///endregion Events

  ///region States

  ///endregion States

  ///region Type

  @override
  PuppiesExtraDetailsEvents get events => this;

  @override
  PuppiesExtraDetailsStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$fetchExtraDetailsEvent.close();
    super.dispose();
  }
}
