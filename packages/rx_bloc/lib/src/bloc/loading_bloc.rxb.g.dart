// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'loading_bloc.dart';

/// LoadingBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class LoadingBlocType extends RxBlocTypeBase {
  LoadingBlocEvents get events;

  LoadingBlocStates get states;
}

/// $LoadingBloc class - extended by the LoadingBloc bloc
/// {@nodoc}
abstract class $LoadingBloc
    implements LoadingBlocEvents, LoadingBlocStates, LoadingBlocType {
  ///region Events

  ///region setLoading

  final _$setLoadingEvent = PublishSubject<Result>();
  @override
  void setResult({required Result result}) => _$setLoadingEvent.add(result);

  ///endregion setLoading

  ///endregion Events

  ///region States

  ///region isLoading
  late final Stream<Result> _isLoadingState = _mapToIsLoadingState();

  @override
  Stream<Result> get result => _isLoadingState;

  Stream<Result> _mapToIsLoadingState();

  ///endregion isLoading

  ///endregion States

  ///region Type

  @override
  LoadingBlocEvents get events => this;

  @override
  LoadingBlocStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams

  @override
  void dispose() {
    _$setLoadingEvent.close();
  }
}
