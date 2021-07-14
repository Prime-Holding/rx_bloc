import 'package:github_search/base/models/github_repo.dart';
import 'package:github_search/base/repositories/github_repos_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

part 'github_repo_list_bloc.rxb.g.dart';
part 'github_repo_list_bloc_extensions.dart';

/// A contract class containing all events of the GithubRepoBloC.
abstract class GithubRepoListBlocEvents {
  /// Load the next page of data. If reset is true, refresh the data and load
  /// the very first page
  void loadPage({bool reset = false});
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
}

/// GithubRepo Bloc
@RxBloc()
class GithubRepoListBloc extends $GithubRepoListBloc {
  /// GithubRepoListBloc default constructor
  GithubRepoListBloc({required GithubReposRepository repository}) {
    _$loadPageEvent
        // Start the data fetching immediately when the page loads
        .startWith(true)
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

  /// Disposes of all streams to prevent memory leaks
  @override
  void dispose() {
    _paginatedList.close();
    super.dispose();
  }
}
