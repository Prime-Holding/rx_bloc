// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

import 'package:example/bloc/counter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/bloc/rx_bloc_base.dart';

abstract class CounterBlocType extends RxBlocTypeBase {
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

  ///region incrementEnabled
  Stream<bool> _incrementEnabledState;

  @override
  Stream<bool> get incrementEnabled =>
      _incrementEnabledState ??= mapToIncrementEnabledState();

  @protected
  Stream<bool> mapToIncrementEnabledState();

  ///endregion incrementEnabled

  ///region decrementEnabled
  Stream<bool> _decrementEnabledState;

  @override
  Stream<bool> get decrementEnabled =>
      _decrementEnabledState ??= mapToDecrementEnabledState();

  @protected
  Stream<bool> mapToDecrementEnabledState();

  ///endregion decrementEnabled

  ///region infoMessage
  Stream<String> _infoMessageState;

  @override
  Stream<String> get infoMessage =>
      _infoMessageState ??= mapToInfoMessageState();

  @protected
  Stream<String> mapToInfoMessageState();

  ///endregion infoMessage

  ///endregion States

  ///region Type

  @override
  CounterBlocEvents get events => this;

  @override
  CounterBlocStates get states => this;

  ///endregion Type
  @override
  void dispose() {
    $incrementEvent.close();
    $decrementEvent.close();
    super.dispose();
  }
}
