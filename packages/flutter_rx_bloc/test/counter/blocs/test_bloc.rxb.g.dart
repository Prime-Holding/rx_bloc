// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'test_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class TestBlocType extends RxBlocTypeBase {
  TestBlocEvents get events;
  TestBlocStates get states;
}

/// [$TestBloc] extended by the [TestBloc]
/// {@nodoc}
abstract class $TestBloc extends RxBlocBase
    implements TestBlocEvents, TestBlocStates, TestBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [setLoading]
  final _$setLoadingEvent = PublishSubject<_SetLoadingEventArgs>();

  /// The state of [isLoadingWithTag] implemented in
  /// [_mapToIsLoadingWithTagState]
  late final Stream<LoadingWithTag> _isLoadingWithTagState =
      _mapToIsLoadingWithTagState();

  @override
  void setLoading(bool isLoading, {String tag = ''}) =>
      _$setLoadingEvent.add(_SetLoadingEventArgs(isLoading, tag: tag));

  @override
  Stream<LoadingWithTag> get isLoadingWithTag => _isLoadingWithTagState;

  Stream<LoadingWithTag> _mapToIsLoadingWithTagState();

  @override
  TestBlocEvents get events => this;

  @override
  TestBlocStates get states => this;

  @override
  void dispose() {
    _$setLoadingEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [TestBlocEvents.setLoading] event
class _SetLoadingEventArgs {
  const _SetLoadingEventArgs(this.isLoading, {this.tag = ''});

  final bool isLoading;

  final String tag;
}
