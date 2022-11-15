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
  final _$openTabEvent = PublishSubject<int>();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [tabIndex] implemented in [_mapToTabIndexState]
  late final Stream<int> _tabIndexState = _mapToTabIndexState();

  @override
  void openTab(int index) => _$openTabEvent.add(index);

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<int> get tabIndex => _tabIndexState;

  Stream<String> _mapToErrorsState();

  Stream<int> _mapToTabIndexState();

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
