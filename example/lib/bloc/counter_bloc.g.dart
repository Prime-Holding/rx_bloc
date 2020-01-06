// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

import 'package:example/bloc/counter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/bloc/rx_bloc_base.dart';

abstract class CounterBlocType {
  CounterBlocEvents get events;

  CounterBlocStates get states;
}

abstract class $CounterBloc extends RxBlocBase
    implements CounterBlocEvents, CounterBlocStates, CounterBlocType {
  ///region Events

  ///region increment
  @protected
  final $incrementEvent = PublishSubject<void>();

  @override
  void increment() => $incrementEvent.add(null);

  ///endregion increment

  ///region decrement
  @protected
  final $decrementEvent = PublishSubject<void>();

  @override
  void decrement() => $decrementEvent.add(null);

  ///endregion decrement

  ///endregion Events

  ///region States

  ///region count
  Stream<String> _countState;

  @override
  Stream<String> get count => _countState ??= mapToCountState();

  @protected
  Stream<String> mapToCountState();

  ///endregion count

  ///endregion States

  ///region Type

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  ///endregion Type

}
