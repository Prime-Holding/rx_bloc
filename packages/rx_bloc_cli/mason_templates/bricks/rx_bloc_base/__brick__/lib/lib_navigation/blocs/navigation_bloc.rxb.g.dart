// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'navigation_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class NavigationBlocType extends RxBlocTypeBase {
  NavigationBlocEvents get events;
  NavigationBlocStates get states;
}

/// [$NavigationBloc] extended by the [NavigationBloc]
/// {@nodoc}
abstract class $NavigationBloc extends RxBlocBase
    implements NavigationBlocEvents, NavigationBlocStates, NavigationBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [goTo]
  final _$goToEvent = PublishSubject<_GoToEventArgs>();

  /// Тhe [Subject] where events sink to by calling [pushTo]
  final _$pushToEvent = PublishSubject<_PushToEventArgs>();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

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
  void pushTo(
    RouteData route, {
    Object? extra,
  }) =>
      _$pushToEvent.add(_PushToEventArgs(
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
  NavigationBlocEvents get events => this;

  @override
  NavigationBlocStates get states => this;

  @override
  void dispose() {
    _$goToEvent.close();
    _$pushToEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [NavigationBlocEvents.goTo] event
class _GoToEventArgs {
  const _GoToEventArgs(
    this.route, {
    this.extra,
  });

  final RouteData route;

  final Object? extra;
}

/// Helps providing the arguments in the [Subject.add] for
/// [NavigationBlocEvents.pushTo] event
class _PushToEventArgs {
  const _PushToEventArgs(
    this.route, {
    this.extra,
  });

  final RouteData route;

  final Object? extra;
}
