// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_bloc/bloc/rx_bloc_base.dart';

import 'details_bloc.dart';

abstract class DetailsBlocType extends RxBlocTypeBase {
  DetailsBlocEvents get events;

  DetailsBlocStates get states;
}

abstract class $DetailsBloc extends RxBlocBase
    implements DetailsBlocEvents, DetailsBlocStates, DetailsBlocType {
  ///region Events

  ///region fetch
  @protected
  final $fetchEvent = PublishSubject<void>();

  @override
  void fetch() => $fetchEvent.add(null);

  ///endregion fetch

  ///endregion Events

  ///region States

  ///region details
  Stream<String> _detailsState;

  @override
  Stream<String> get details => _detailsState ??= mapToDetailsState();

  @protected
  Stream<String> mapToDetailsState();

  ///endregion details

  ///endregion States

  ///region Type

  @override
  DetailsBlocEvents get events => this;

  @override
  DetailsBlocStates get states => this;

  ///endregion Type
  @override
  void dispose() {
    $fetchEvent.close();
    super.dispose();
  }
}
