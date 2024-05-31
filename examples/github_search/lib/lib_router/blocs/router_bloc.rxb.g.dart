// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'router_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class RouterBlocType extends RxBlocTypeBase {
  RouterBlocEvents get events;
  RouterBlocStates get states;
}

/// [$RouterBloc] extended by the [RouterBloc]
/// @nodoc
abstract class $RouterBloc extends RxBlocBase
    implements RouterBlocEvents, RouterBlocStates, RouterBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [go]
  final _$goEvent = PublishSubject<({RouteDataModel route, Object? extra})>();

  /// Тhe [Subject] where events sink to by calling [goToLocation]
  final _$goToLocationEvent = PublishSubject<String>();

  /// Тhe [Subject] where events sink to by calling [push]
  final _$pushEvent = PublishSubject<({RouteDataModel route, Object? extra})>();

  /// Тhe [Subject] where events sink to by calling [pushReplace]
  final _$pushReplaceEvent =
      PublishSubject<({RouteDataModel route, Object? extra})>();

  /// Тhe [Subject] where events sink to by calling [pop]
  final _$popEvent = PublishSubject<Object?>();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final ConnectableStream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [navigationPath] implemented in [_mapToNavigationPathState]
  late final ConnectableStream<void> _navigationPathState =
      _mapToNavigationPathState();

  @override
  void go(
    RouteDataModel route, {
    Object? extra,
  }) =>
      _$goEvent.add((
        route: route,
        extra: extra,
      ));

  @override
  void goToLocation(String location) => _$goToLocationEvent.add(location);

  @override
  void push(
    RouteDataModel route, {
    Object? extra,
  }) =>
      _$pushEvent.add((
        route: route,
        extra: extra,
      ));

  @override
  void pushReplace(
    RouteDataModel route, {
    Object? extra,
  }) =>
      _$pushReplaceEvent.add((
        route: route,
        extra: extra,
      ));

  @override
  void pop([Object? result]) => _$popEvent.add(result);

  @override
  ConnectableStream<ErrorModel> get errors => _errorsState;

  @override
  ConnectableStream<void> get navigationPath => _navigationPathState;

  ConnectableStream<ErrorModel> _mapToErrorsState();

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
    _$pushReplaceEvent.close();
    _$popEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

// ignore: unused_element
typedef _GoEventArgs = ({RouteDataModel route, Object? extra});

// ignore: unused_element
typedef _PushEventArgs = ({RouteDataModel route, Object? extra});

// ignore: unused_element
typedef _PushReplaceEventArgs = ({RouteDataModel route, Object? extra});
