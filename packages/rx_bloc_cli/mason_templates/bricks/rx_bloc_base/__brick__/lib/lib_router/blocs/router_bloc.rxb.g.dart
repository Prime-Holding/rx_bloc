// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'router_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class RouterBlocType extends RxBlocTypeBase {
  RouterBlocEvents get events;
  RouterBlocStates get states;
}

/// [$RouterBloc] extended by the [RouterBloc]
/// {@nodoc}
abstract class $RouterBloc extends RxBlocBase
    implements RouterBlocEvents, RouterBlocStates, RouterBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [go]
  final _$goEvent = PublishSubject<_GoEventArgs>();

  /// Тhe [Subject] where events sink to by calling [goToLocation]
  final _$goToLocationEvent = PublishSubject<String>();

  /// Тhe [Subject] where events sink to by calling [push]
  final _$pushEvent = PublishSubject<_PushEventArgs>();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [navigationPath] implemented in [_mapToNavigationPathState]
  late final ConnectableStream<void> _navigationPathState =
      _mapToNavigationPathState();

  @override
  void go(
    RouteDataModel route, {
    Object? extra,
  }) =>
      _$goEvent.add(_GoEventArgs(
        route,
        extra: extra,
      ));

  @override
  void goToLocation(String location) => _$goToLocationEvent.add(location);

  @override
  void push(
    RouteDataModel route, {
    Object? extra,
  }) =>
      _$pushEvent.add(_PushEventArgs(
        route,
        extra: extra,
      ));

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  ConnectableStream<void> get navigationPath => _navigationPathState;

  Stream<ErrorModel> _mapToErrorsState();

  ConnectableStream<void> _mapToNavigationPathState();

  @override
  RouterBlocEvents get events => this;

  @override
  RouterBlocStates get states => this;

  @override
  void dispose() {
    _$goEvent.close();
    _$goToLocationEvent.close();
    _$pushEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [RouterBlocEvents.go] event
class _GoEventArgs {
  const _GoEventArgs(
    this.route, {
    this.extra,
  });

  final RouteDataModel route;

  final Object? extra;
}

/// Helps providing the arguments in the [Subject.add] for
/// [RouterBlocEvents.push] event
class _PushEventArgs {
  const _PushEventArgs(
    this.route, {
    this.extra,
  });

  final RouteDataModel route;

  final Object? extra;
}
