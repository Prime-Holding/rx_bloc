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

  /// Тhe [Subject] where events sink to by calling [goTo]
  final _$goToEvent = PublishSubject<_GoToEventArgs>();

  /// Тhe [Subject] where events sink to by calling [goToLocation]
  final _$goToLocationEvent = PublishSubject<String>();

  /// Тhe [Subject] where events sink to by calling [pushTo]
  final _$pushToEvent = PublishSubject<_PushToEventArgs>();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [navigationPath] implemented in [_mapToNavigationPathState]
  late final ConnectableStream<void> _navigationPathState =
      _mapToNavigationPathState();

  @override
  void goTo(
    RouteData route, {
    Object? extra,
  }) =>
      _$goToEvent.add(_GoToEventArgs(
        route,
        extra: extra,
      ));

  @override
  void goToLocation(String location) => _$goToLocationEvent.add(location);

  @override
  void pushTo(
    RouteData route, {
    Object? extra,
  }) =>
      _$pushToEvent.add(_PushToEventArgs(
        route,
        extra: extra,
      ));

  @override
  Stream<String> get errors => _errorsState;

  @override
  ConnectableStream<void> get navigationPath => _navigationPathState;

  Stream<String> _mapToErrorsState();

  ConnectableStream<void> _mapToNavigationPathState();

  @override
  RouterBlocEvents get events => this;

  @override
  RouterBlocStates get states => this;

  @override
  void dispose() {
    _$goToEvent.close();
    _$goToLocationEvent.close();
    _$pushToEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [RouterBlocEvents.goTo] event
class _GoToEventArgs {
  const _GoToEventArgs(
    this.route, {
    this.extra,
  });

  final RouteData route;

  final Object? extra;
}

/// Helps providing the arguments in the [Subject.add] for
/// [RouterBlocEvents.pushTo] event
class _PushToEventArgs {
  const _PushToEventArgs(
    this.route, {
    this.extra,
  });

  final RouteData route;

  final Object? extra;
}
