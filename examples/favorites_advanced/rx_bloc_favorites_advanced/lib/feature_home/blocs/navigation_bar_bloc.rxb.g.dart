// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'navigation_bar_bloc.dart';

/// NavigationBarBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class NavigationBarBlocType extends RxBlocTypeBase {
  NavigationBarEvents get events;

  NavigationBarStates get states;
}

/// $NavigationBarBloc class - extended by the NavigationBarBloc bloc
/// {@nodoc}
abstract class $NavigationBarBloc extends RxBlocBase
    implements NavigationBarEvents, NavigationBarStates, NavigationBarBlocType {
  ///region Events

  ///region selectPage

  final _$selectPageEvent = PublishSubject<NavigationItemType>();
  @override
  void selectPage(NavigationItemType item) => _$selectPageEvent.add(item);

  ///endregion selectPage

  ///endregion Events

  ///region States

  ///region title
  Stream<String> _titleState;

  @override
  Stream<String> get title => _titleState ??= _mapToTitleState();

  Stream<String> _mapToTitleState();

  ///endregion title

  ///endregion States

  ///region Type

  @override
  NavigationBarEvents get events => this;

  @override
  NavigationBarStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$selectPageEvent.close();
    super.dispose();
  }
}
