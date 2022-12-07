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

  /// Тhe [Subject] where events sink to by calling [openTab]
  final _$openTabEvent = PublishSubject<NavigationTabs>();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [tab] implemented in [_mapToTabState]
  late final Stream<NavigationTabs> _tabState = _mapToTabState();

  @override
  void openTab(NavigationTabs tab) => _$openTabEvent.add(tab);

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<NavigationTabs> get tab => _tabState;

  Stream<String> _mapToErrorsState();

  Stream<NavigationTabs> _mapToTabState();

  @override
  NavigationBlocEvents get events => this;

  @override
  NavigationBlocStates get states => this;

  @override
  void dispose() {
    _$openTabEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
