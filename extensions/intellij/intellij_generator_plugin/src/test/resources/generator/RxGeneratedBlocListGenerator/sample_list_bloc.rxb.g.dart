// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'profile_list_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class ProfileListBlocType extends RxBlocTypeBase {
  /// Events of the bloc
  ProfileListBlocEvents get events;

  /// States of the bloc
  ProfileListBlocStates get states;
}

/// [$ProfileList] extended by the [ProfileList]
/// {@nodoc}
abstract class $ProfileListBloc extends RxBlocBase
    implements ProfileListBlocEvents, ProfileListBlocStates, ProfileListBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [loadPage]
  final _$loadPageEvent = PublishSubject<bool>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [paginatedList] implemented in [_mapToPaginatedListState]
  late final Stream<PaginatedList<Profile>> _paginatedListState =
  _mapToPaginatedListState();

  @override
  void loadPage({bool reset = false}) => _$loadPageEvent.add(reset);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<ErrorModel> get errors => _errorsState;

  @override
  Stream<PaginatedList<Profile>> get paginatedList => _paginatedListState;

  Stream<bool> _mapToIsLoadingState();

  Stream<ErrorModel> _mapToErrorsState();

  Stream<PaginatedList<Profile>> _mapToPaginatedListState();

  @override
  ProfileListBlocEvents get events => this;

  @override
  ProfileListBlocStates get states => this;

  @override
  void dispose() {
    _$loadPageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}