// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'navigation_bar_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class NavigationBarBlocType extends RxBlocTypeBase {
  NavigationBarBlocEvents get events;
  NavigationBarBlocStates get states;
}

/// [$NavigationBarBloc] extended by the [NavigationBarBloc]
/// {@nodoc}
abstract class $NavigationBarBloc extends RxBlocBase
    implements
        NavigationBarBlocEvents,
        NavigationBarBlocStates,
        NavigationBarBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [selectPage]
  final _$selectPageEvent = PublishSubject<NavigationItemType>();

  /// The state of [title] implemented in [_mapToTitleState]
  late final Stream<String> _titleState = _mapToTitleState();

  @override
  void selectPage(NavigationItemType item) => _$selectPageEvent.add(item);

  @override
  Stream<String> get title => _titleState;

  Stream<String> _mapToTitleState();

  @override
  NavigationBarBlocEvents get events => this;

  @override
  NavigationBarBlocStates get states => this;

  @override
  void dispose() {
    _$selectPageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
