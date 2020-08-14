// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'news_bloc.dart';

/// NewsBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class NewsBlocType extends RxBlocTypeBase {
  NewsBlocEvents get events;

  NewsBlocStates get states;
}

/// $NewsBloc class - extended by the NewsBloc bloc
/// {@nodoc}
abstract class $NewsBloc extends RxBlocBase
    implements NewsBlocEvents, NewsBlocStates, NewsBlocType {
  ///region Events

  ///region fetch

  final _$fetchEvent = PublishSubject<void>();
  @override
  void fetch() => _$fetchEvent.add(null);

  ///endregion fetch

  ///endregion Events

  ///region States

  ///region news
  Stream<List<News>> _newsState;

  @override
  Stream<List<News>> get news => _newsState ??= _mapToNewsState();

  Stream<List<News>> _mapToNewsState();

  ///endregion news

  ///endregion States

  ///region Type

  @override
  NewsBlocEvents get events => this;

  @override
  NewsBlocStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams
  void dispose() {
    _$fetchEvent.close();
    super.dispose();
  }
}
