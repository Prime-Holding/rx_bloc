// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'coordinator_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class CoordinatorBlocType extends RxBlocTypeBase {
  CoordinatorEvents get events;
  CoordinatorStates get states;
}

/// [$CoordinatorBloc] extended by the [CoordinatorBloc]
/// {@nodoc}
abstract class $CoordinatorBloc extends RxBlocBase
    implements CoordinatorEvents, CoordinatorStates, CoordinatorBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [authenticated]
  final _$authenticatedEvent = PublishSubject<bool>();

  @override
  void authenticated({required bool isAuthenticated}) =>
      _$authenticatedEvent.add(isAuthenticated);

  @override
  CoordinatorEvents get events => this;

  @override
  CoordinatorStates get states => this;

  @override
  void dispose() {
    _$authenticatedEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
