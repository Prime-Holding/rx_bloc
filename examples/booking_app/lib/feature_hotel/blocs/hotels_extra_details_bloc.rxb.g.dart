// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'hotels_extra_details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class HotelsExtraDetailsBlocType extends RxBlocTypeBase {
  HotelsExtraDetailsEvents get events;
  HotelsExtraDetailsStates get states;
}

/// [$HotelsExtraDetailsBloc] extended by the [HotelsExtraDetailsBloc]
/// {@nodoc}
abstract class $HotelsExtraDetailsBloc extends RxBlocBase
    implements
        HotelsExtraDetailsEvents,
        HotelsExtraDetailsStates,
        HotelsExtraDetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchExtraDetails]
  final _$fetchExtraDetailsEvent = PublishSubject<Hotel>();

  @override
  void fetchExtraDetails(Hotel hotel) => _$fetchExtraDetailsEvent.add(hotel);

  @override
  HotelsExtraDetailsEvents get events => this;

  @override
  HotelsExtraDetailsStates get states => this;

  @override
  void dispose() {
    _$fetchExtraDetailsEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
