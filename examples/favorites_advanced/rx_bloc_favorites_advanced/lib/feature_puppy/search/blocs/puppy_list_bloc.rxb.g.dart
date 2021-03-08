// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_list_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class PuppyListBlocType extends RxBlocTypeBase {
  PuppyListEvents get events;
  PuppyListStates get states;
}

/// [$PuppyListBloc] extended by the [PuppyListBloc]
/// {@nodoc}
abstract class $PuppyListBloc extends RxBlocBase
    implements PuppyListEvents, PuppyListStates, PuppyListBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [filterPuppies]
  final _$filterPuppiesEvent = BehaviorSubject.seeded('');

  /// Тhe [Subject] where events sink to by calling [reloadFavoritePuppies]
  final _$reloadFavoritePuppiesEvent = BehaviorSubject.seeded(false);

  @override
  void filterPuppies({required String query}) =>
      _$filterPuppiesEvent.add(query);

  @override
  void reloadFavoritePuppies({required bool silently}) =>
      _$reloadFavoritePuppiesEvent.add(silently);

  @override
  PuppyListEvents get events => this;

  @override
  PuppyListStates get states => this;

  @override
  void dispose() {
    _$filterPuppiesEvent.close();
    _$reloadFavoritePuppiesEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
