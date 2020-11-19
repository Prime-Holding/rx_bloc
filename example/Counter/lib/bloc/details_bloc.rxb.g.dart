// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'details_bloc.dart';

/// DetailsBlocType class used for bloc event and state access from widgets
/// {@nodoc}
abstract class DetailsBlocType extends RxBlocTypeBase {
  DetailsBlocEvents get events;

  DetailsBlocStates get states;
}

/// $DetailsBloc class - extended by the DetailsBloc bloc
/// {@nodoc}
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
  Stream<Result<String>> _detailsState;

  @override
  Stream<Result<String>> get details => _detailsState ??= _mapToDetailsState();

  Stream<Result<String>> _mapToDetailsState();

  ///endregion details

  ///endregion States

  ///region Type

  @override
  DetailsBlocEvents get events => this;

  @override
  DetailsBlocStates get states => this;

  ///endregion Type

  /// Dispose of all the opened streams
  void dispose() {
    _$fetchEvent.close();
    super.dispose();
  }
}
