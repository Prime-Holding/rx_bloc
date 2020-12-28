// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'puppy_edit_bloc.dart';

/// PuppyEditBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class PuppyEditBlocType extends RxBlocTypeBase {
  PuppyEditBlocEvents get events;

  PuppyEditBlocStates get states;
}

/// $PuppyEditBloc class - extended by the PuppyEditBloc bloc
/// {@nodoc}
abstract class $PuppyEditBloc extends RxBlocBase
    implements PuppyEditBlocEvents, PuppyEditBlocStates, PuppyEditBlocType {
  ///region Events

  ///region updatePuppy

  final _$updatePuppyEvent = PublishSubject<_UpdatePuppyEventArgs>();
  @override
  void updatePuppy(Puppy newPuppy, Puppy oldPuppy) =>
      _$updatePuppyEvent.add(_UpdatePuppyEventArgs(
        newPuppy: newPuppy,
        oldPuppy: oldPuppy,
      ));

  ///endregion updatePuppy

  ///endregion Events

  ///region States

  ///endregion States

  ///region Type

  @override
  PuppyEditBlocEvents get events => this;

  @override
  PuppyEditBlocStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$updatePuppyEvent.close();
    super.dispose();
  }
}

/// region Argument classes

/// region _UpdatePuppyEventArgs class

/// {@nodoc}
class _UpdatePuppyEventArgs {
  final Puppy newPuppy;
  final Puppy oldPuppy;

  const _UpdatePuppyEventArgs({
    this.newPuppy,
    this.oldPuppy,
  });
}

/// endregion _UpdatePuppyEventArgs class

/// endregion Argument classes
