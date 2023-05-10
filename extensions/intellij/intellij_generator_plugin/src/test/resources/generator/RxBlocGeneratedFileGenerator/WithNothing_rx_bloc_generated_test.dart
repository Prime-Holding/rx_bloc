// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'profile_dart_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class ProfileDartBlocType extends RxBlocTypeBase {
  ProfileDartBlocEvents get events;
  ProfileDartBlocStates get states;
}

/// [$ProfileDart] extended by the [ProfileDart]
/// {@nodoc}
abstract class $ProfileDartBloc extends RxBlocBase
    implements ProfileDartBlocEvents, ProfileDartBlocStates, ProfileDartBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchData]
  final _$fetchDataEvent = PublishSubject<void>();

  /// The state of [data] implemented in [_mapToDataState]
  late final Stream<Result<String>> _dataState = _mapToDataState();

  @override
  Stream<Result<String>> get data => _dataState;

  Stream<Result<String>> _mapToDataState();

  @override
  void fetchData() => _$fetchDataEvent.add(null);

  @override
  ProfileDartBlocEvents get events => this;

  @override
  ProfileDartBlocStates get states => this;

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}