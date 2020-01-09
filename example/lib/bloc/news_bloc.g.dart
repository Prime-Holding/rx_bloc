// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

import 'package:example/bloc/news_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/bloc/rx_bloc_base.dart';

abstract class NewsBlocType extends RxBlocTypeBase {
  NewsBlocEvents get events;

  NewsBlocStates get states;
}

abstract class $NewsBloc extends RxBlocBase
    implements NewsBlocEvents, NewsBlocStates, NewsBlocType {
  ///region Events

  ///region fetch
  final $fetchEvent = PublishSubject<void>();

  @override
  void fetch() => $fetchEvent.add(null);

  ///endregion fetch

  ///endregion Events

  ///region States

  ///region news
  Stream<List<News>> _newsState;

  @override
  Stream<List<News>> get news => _newsState ??= mapToNewsState();

  @protected
  Stream<List<News>> mapToNewsState();

  ///endregion news

  ///endregion States

  ///region Type

  @override
  NewsBlocEvents get events => this;

  @override
  NewsBlocStates get states => this;

  ///endregion Type

}
