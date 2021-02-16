// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'navigation_bar_bloc.dart';

/// NavigationBarBlocType class used for blocClass event and state access from widgets
/// {@nodoc}
abstract class NavigationBarBlocType extends RxBlocTypeBase {
  NavigationBarEvents get events;
  NavigationBarStates get states;
}

/// $NavigationBarBloc class - extended by the CounterBloc bloc
/// {@nodoc}
abstract class $NavigationBarBloc extends RxBlocBase
    implements NavigationBarEvents, NavigationBarStates, NavigationBarBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [selectPage]
  final _$selectPageEvent = PublishSubject<NavigationItemType>();

  /// The state of [title] implemented in [_mapToTitleState]
  Stream<String> _titleState;

  @override
  void selectPage(NavigationItemType item) => _$selectPageEvent.add(item);

  @override
  Stream<String> get title => _titleState ??= _mapToTitleState();

  Stream<String> _mapToTitleState();

  @override
  NavigationBarEvents get events => this;

  @override
  NavigationBarStates get states => this;

  @override
  void dispose() {
    _$selectPageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
