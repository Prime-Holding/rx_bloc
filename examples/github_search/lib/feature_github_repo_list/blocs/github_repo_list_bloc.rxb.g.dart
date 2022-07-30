// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'github_repo_list_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class GithubRepoListBlocType extends RxBlocTypeBase {
  GithubRepoListBlocEvents get events;
  GithubRepoListBlocStates get states;
}

/// [$GithubRepoListBloc] extended by the [GithubRepoListBloc]
/// {@nodoc}
abstract class $GithubRepoListBloc extends RxBlocBase
    implements
        GithubRepoListBlocEvents,
        GithubRepoListBlocStates,
        GithubRepoListBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [loadPage]
  final _$loadPageEvent = PublishSubject<_LoadPageEventArgs>();

  /// Тhe [Subject] where events sink to by calling [filterByQuery]
  final _$filterByQueryEvent = BehaviorSubject<String>.seeded('Flutter');

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [paginatedList] implemented in [_mapToPaginatedListState]
  late final Stream<PaginatedList<GithubRepo>> _paginatedListState =
      _mapToPaginatedListState();

  @override
  void loadPage({bool reset = false, bool hardReset = false}) => _$loadPageEvent
      .add(_LoadPageEventArgs(reset: reset, hardReset: hardReset));

  @override
  void filterByQuery(String query) => _$filterByQueryEvent.add(query);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<PaginatedList<GithubRepo>> get paginatedList => _paginatedListState;

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  Stream<PaginatedList<GithubRepo>> _mapToPaginatedListState();

  @override
  GithubRepoListBlocEvents get events => this;

  @override
  GithubRepoListBlocStates get states => this;

  @override
  void dispose() {
    _$loadPageEvent.close();
    _$filterByQueryEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// Helps providing the arguments in the [Subject.add] for
/// [GithubRepoListBlocEvents.loadPage] event
class _LoadPageEventArgs {
  const _LoadPageEventArgs({this.reset = false, this.hardReset = false});

  final bool reset;

  final bool hardReset;
}
