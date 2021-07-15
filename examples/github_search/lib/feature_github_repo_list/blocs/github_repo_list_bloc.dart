import 'package:github_search/base/models/github_repo.dart';
import 'package:github_search/base/repositories/github_repos_repository.dart';
import 'package:github_search/feature_github_repo_list/models/github_repo_paginated_search.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

part 'github_repo_list_bloc.rxb.g.dart';
part 'github_repo_list_bloc_extensions.dart';

/// A contract class containing all events of the GithubRepoBloC.
abstract class GithubRepoListBlocEvents {
  /// Load the next page of data.
  ///
  /// - If [reset] is true, refresh the data and load the very first page
  /// - If [hardReset] is true, the list will be cleared and a loading
  /// indicator will appear.
  void loadPage({bool reset = false, bool hardReset = false});

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: 'Flutter')
  void filterByQuery(String query);
}

/// A contract class containing all states of the GithubRepoListBloC.
abstract class GithubRepoListBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  /// The paginated list data
  Stream<PaginatedList<GithubRepo>> get paginatedList;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;

  @RxBlocIgnoreState()
  Stream<String> get queryFilter;
}

/// GithubRepo Bloc
@RxBloc()
class GithubRepoListBloc extends $GithubRepoListBloc {
  /// GithubRepoListBloc default constructor
  GithubRepoListBloc({required GithubReposRepository repository}) {
    Rx.merge([
      _$loadPageEvent.mapToPaginatedSearch(_$filterByQueryEvent),
      _$filterByQueryEvent.mapToPaginatedSearch(),
    ])
        // Start the data fetching immediately when the page loads
        .startWithDefaults(_$filterByQueryEvent)
        .fetchData(repository, _paginatedList)
        // Enable state handling by the current bloc
        .setResultStateHandler(this)
        // Merge the data in the _paginatedList
        .mergeWithPaginatedList(_paginatedList)
        .bind(_paginatedList)
        // Make sure we dispose the subscription
        .disposedBy(_compositeSubscription);
  }

  /// Internal paginated list stream
  final _paginatedList = BehaviorSubject<PaginatedList<GithubRepo>>.seeded(
    PaginatedList<GithubRepo>(
      list: [],
      pageSize: 50,
    ),
  );

  @override
  Future<void> get refreshDone async => _paginatedList.waitToLoad();

  @override
  Stream<PaginatedList<GithubRepo>> _mapToPaginatedListState() =>
      _paginatedList;

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((event) => event.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<String> get queryFilter => _$filterByQueryEvent;

  /// Disposes of all streams to prevent memory leaks
  @override
  void dispose() {
    _paginatedList.close();
    super.dispose();
  }
}
