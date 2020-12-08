// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_manage_bloc.dart';

/// PuppyManageBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class PuppyManageBlocType extends RxBlocTypeBase {
  PuppyManageEvents get events;

  PuppyManageStates get states;
}

/// $PuppyManageBloc class - extended by the PuppyManageBloc bloc
/// {@nodoc}
abstract class $PuppyManageBloc extends RxBlocBase
    implements PuppyManageEvents, PuppyManageStates, PuppyManageBlocType {
  ///region Events

  ///region markAsFavorite

  final _$markAsFavoriteEvent = PublishSubject<_MarkAsFavoriteEventArgs>();
  @override
  void markAsFavorite({Puppy puppy, bool isFavorite}) =>
      _$markAsFavoriteEvent.add(_MarkAsFavoriteEventArgs(
        puppy: puppy,
        isFavorite: isFavorite,
      ));

  ///endregion markAsFavorite

  ///endregion Events

  ///region States

  ///endregion States

  ///region Type

  @override
  PuppyManageEvents get events => this;

  @override
  PuppyManageStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$markAsFavoriteEvent.close();
    super.dispose();
  }
}

/// region Argument classes

/// region _MarkAsFavoriteEventArgs class

/// {@nodoc}
class _MarkAsFavoriteEventArgs {
  final Puppy puppy;
  final bool isFavorite;

  const _MarkAsFavoriteEventArgs({
    this.puppy,
    this.isFavorite,
  });
}

/// endregion _MarkAsFavoriteEventArgs class

/// endregion Argument classes
