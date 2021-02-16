// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppies_extra_details_bloc.dart';

/// PuppiesExtraDetailsBlocType class used for blocClass event and state access from widgets
/// {@nodoc}
abstract class PuppiesExtraDetailsBlocType extends RxBlocTypeBase {
  PuppiesExtraDetailsEvents get events;
  PuppiesExtraDetailsStates get states;
}

/// $PuppiesExtraDetailsBloc class - extended by the CounterBloc bloc
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
