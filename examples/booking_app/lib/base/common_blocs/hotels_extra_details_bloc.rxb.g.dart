// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'hotels_extra_details_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class HotelsExtraDetailsBlocType extends RxBlocTypeBase {
  HotelsExtraDetailsBlocEvents get events;
  HotelsExtraDetailsBlocStates get states;
}

/// [$HotelsExtraDetailsBloc] extended by the [HotelsExtraDetailsBloc]
/// {@nodoc}
abstract class $HotelsExtraDetailsBloc extends RxBlocBase
    implements
        HotelsExtraDetailsBlocEvents,
        HotelsExtraDetailsBlocStates,
        HotelsExtraDetailsBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchExtraDetails]
  final _$fetchExtraDetailsEvent =
      PublishSubject<_FetchExtraDetailsEventArgs>();

  @override
  void fetchExtraDetails(
    Hotel hotel, {
    bool allProps = false,
  }) =>
      _$fetchExtraDetailsEvent.add(_FetchExtraDetailsEventArgs(
        hotel,
        allProps: allProps,
      ));

  @override
  HotelsExtraDetailsBlocEvents get events => this;

  @override
  HotelsExtraDetailsBlocStates get states => this;

  @override
  void dispose() {
    _$fetchExtraDetailsEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [HotelsExtraDetailsBlocEvents.fetchExtraDetails] event
class _FetchExtraDetailsEventArgs {
  const _FetchExtraDetailsEventArgs(
    this.hotel, {
    this.allProps = false,
  });

  final Hotel hotel;

  final bool allProps;
}
