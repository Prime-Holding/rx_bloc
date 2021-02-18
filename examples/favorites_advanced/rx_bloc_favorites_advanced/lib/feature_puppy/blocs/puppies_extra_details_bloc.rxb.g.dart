// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppies_extra_details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class PuppiesExtraDetailsBlocType extends RxBlocTypeBase {
  PuppiesExtraDetailsEvents get events;
  PuppiesExtraDetailsStates get states;
}

/// [$PuppiesExtraDetailsBloc] extended by the [PuppiesExtraDetailsBloc]
/// {@nodoc}
abstract class $PuppiesExtraDetailsBloc extends RxBlocBase
    implements
        PuppiesExtraDetailsEvents,
        PuppiesExtraDetailsStates,
        PuppiesExtraDetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchExtraDetails]
  final _$fetchExtraDetailsEvent = PublishSubject<Puppy>();

  @override
  void fetchExtraDetails(Puppy puppy) => _$fetchExtraDetailsEvent.add(puppy);

  @override
  PuppiesExtraDetailsEvents get events => this;

  @override
  PuppiesExtraDetailsStates get states => this;

  @override
  void dispose() {
    _$fetchExtraDetailsEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
