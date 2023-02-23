// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'profile_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class ProfileBlocType extends RxBlocTypeBase {
  ProfileBlocEvents get events;
  ProfileBlocStates get states;
}

/// [$ProfileBloc] extended by the [ProfileBloc]
/// {@nodoc}
abstract class $ProfileBloc extends RxBlocBase
    implements ProfileBlocEvents, ProfileBlocStates, ProfileBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  @override
  ProfileBlocEvents get events => this;

  @override
  ProfileBlocStates get states => this;

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }
}
