// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'details_bloc.dart';

abstract class DetailsBlocType extends RxBlocTypeBase {
  DetailsBlocEvents get events;

  DetailsBlocStates get states;
}

abstract class $DetailsBloc extends RxBlocBase
    implements DetailsBlocEvents, DetailsBlocStates, DetailsBlocType {
  ///region Events

  ///region fetch

  final _$fetchEvent = PublishSubject<void>();
  @override
  void fetch() => _$fetchEvent.add(null);

  ///endregion fetch

  ///endregion Events

  ///region States

  ///region details
  Stream<String> _detailsState;

  @override
  Stream<String> get details => _detailsState ??= _mapToDetailsState();

  Stream<String> _mapToDetailsState();

  ///endregion details

  ///endregion States

  ///region Type

  @override
  DetailsBlocEvents get events => this;

  @override
  DetailsBlocStates get states => this;

  ///endregion Type
  void dispose() {
    _$fetchEvent.close();
    super.dispose();
  }
}
