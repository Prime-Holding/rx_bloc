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

  /// Тhe [Subject] where events sink to by calling [filter]
  final _$filterEvent = BehaviorSubject<String>.seeded('');

  /// Тhe [Subject] where events sink to by calling [reload]
  final _$reloadEvent = BehaviorSubject<_ReloadEventArgs>.seeded(
      const _ReloadEventArgs(reset: true, fullReset: false));

  @override
  void filter({required String query}) => _$filterEvent.add(query);

  @override
  void reload({required bool reset, bool fullReset = false}) =>
      _$reloadEvent.add(_ReloadEventArgs(reset: reset, fullReset: fullReset));

  @override
  PuppyListEvents get events => this;

  @override
  PuppyListStates get states => this;

  @override
  void dispose() {
    _$filterEvent.close();
    _$reloadEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [PuppyListEvents.reload] event
class _ReloadEventArgs {
  const _ReloadEventArgs({required this.reset, this.fullReset = false});

  final bool reset;

  final bool fullReset;
}
