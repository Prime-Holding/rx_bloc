// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'user_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class UserBlocType extends RxBlocTypeBase {
  UserBlocEvents get events;
  UserBlocStates get states;
}

/// [$UserBloc] extended by the [UserBloc]
/// {@nodoc}
abstract class $UserBloc extends RxBlocBase
    implements UserBlocEvents, UserBlocStates, UserBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [loadPage]
  final _$loadPageEvent = PublishSubject<bool>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  Stream<bool>? _isLoadingState;

  /// The state of [errors] implemented in [_mapToErrorsState]
  Stream<String>? _errorsState;

  /// The state of [paginatedList] implemented in [_mapToPaginatedListState]
  Stream<PaginatedList<User>>? _paginatedListState;

  @override
  void loadPage({bool reset = false}) => _$loadPageEvent.add(reset);

  @override
  Stream<bool> get isLoading => _isLoadingState ??= _mapToIsLoadingState();

  @override
  Stream<String> get errors => _errorsState ??= _mapToErrorsState();

  @override
  Stream<PaginatedList<User>> get paginatedList =>
      _paginatedListState ??= _mapToPaginatedListState();

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  Stream<PaginatedList<User>> _mapToPaginatedListState();

  @override
  UserBlocEvents get events => this;

  @override
  UserBlocStates get states => this;

  @override
  void dispose() {
    _$loadPageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
