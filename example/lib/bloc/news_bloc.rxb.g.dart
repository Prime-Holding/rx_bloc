// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'news_bloc.dart';

abstract class NewsBlocType extends RxBlocTypeBase {
  NewsBlocEvents get events;

  NewsBlocStates get states;
}

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

  void dispose() {
    _$fetchEvent.close();
    super.dispose();
  }
}
