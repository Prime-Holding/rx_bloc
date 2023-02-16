// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'coordinator_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class CoordinatorBlocType extends RxBlocTypeBase {
  CoordinatorEvents get events;
  CoordinatorStates get states;
}

/// [$CoordinatorBloc] extended by the [CoordinatorBloc]
/// {@nodoc}
abstract class $CoordinatorBloc extends RxBlocBase
    implements CoordinatorEvents, CoordinatorStates, CoordinatorBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [authenticated]
  final _$authenticatedEvent = PublishSubject<bool>();

  /// Тhe [Subject] where events sink to by calling [errorLogged]
  final _$errorLoggedEvent = PublishSubject<_ErrorLoggedEventArgs>();

  @override
  void authenticated({required bool isAuthenticated}) =>
      _$authenticatedEvent.add(isAuthenticated);

  @override
  void errorLogged({
    required ErrorModel error,
    String? stackTrace,
  }) =>
      _$errorLoggedEvent.add(_ErrorLoggedEventArgs(
        error: error,
        stackTrace: stackTrace,
      ));

  @override
  CoordinatorEvents get events => this;

  @override
  CoordinatorStates get states => this;

  @override
  void dispose() {
    _$authenticatedEvent.close();
    _$errorLoggedEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [CoordinatorEvents.errorLogged] event
class _ErrorLoggedEventArgs {
  const _ErrorLoggedEventArgs({
    required this.error,
    this.stackTrace,
  });

  final ErrorModel error;

  final String? stackTrace;
}
