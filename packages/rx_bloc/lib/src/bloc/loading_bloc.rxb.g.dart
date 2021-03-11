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

  final _$setLoadingEvent = PublishSubject<bool>();
  @override
  void setLoading({required bool isLoading}) =>
      _$setLoadingEvent.add(isLoading);

  ///endregion setLoading

  ///endregion Events

  ///region States

  ///region isLoading
  Stream<bool>? _isLoadingState;

  @override
  Stream<bool> get isLoading => _isLoadingState ??= _mapToIsLoadingState();

  Stream<bool> _mapToIsLoadingState();

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
