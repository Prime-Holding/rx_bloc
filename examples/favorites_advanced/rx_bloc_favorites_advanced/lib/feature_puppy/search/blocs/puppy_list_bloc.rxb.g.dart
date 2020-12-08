// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_list_bloc.dart';

/// PuppyListBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class PuppyListBlocType extends RxBlocTypeBase {
  PuppyListEvents get events;

  PuppyListStates get states;
}

/// $PuppyListBloc class - extended by the PuppyListBloc bloc
/// {@nodoc}
abstract class $PuppyListBloc extends RxBlocBase
    implements PuppyListEvents, PuppyListStates, PuppyListBlocType {
  ///region Events

  ///region filterPuppies

  final _$filterPuppiesEvent = BehaviorSubject.seeded('');
  @override
  void filterPuppies({@required String query}) =>
      _$filterPuppiesEvent.add(query);

  ///endregion filterPuppies

  ///region reloadFavoritePuppies

  final _$reloadFavoritePuppiesEvent = BehaviorSubject.seeded(false);
  @override
  void reloadFavoritePuppies({@required bool silently}) =>
      _$reloadFavoritePuppiesEvent.add(silently);

  ///endregion reloadFavoritePuppies

  ///endregion Events

  ///region States

  ///endregion States

  ///region Type

  @override
  PuppyListEvents get events => this;

  @override
  PuppyListStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$filterPuppiesEvent.close();
    _$reloadFavoritePuppiesEvent.close();
    super.dispose();
  }
}
