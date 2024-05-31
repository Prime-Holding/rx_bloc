import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/github_repo_model.dart';
import '../services/dashboard_service.dart';

part 'dashboard_bloc.rxb.g.dart';

/// A contract class containing all events of the DashboardBloC.
abstract class DashboardBlocEvents {
  /// Fetches the suggestion list
  ///
  /// The result is emitted to [DashboardBloc.suggestionList] state
  void fetchSuggestionList();

  /// Searches fruit by a query string
  ///
  /// The result is emitted to [DashboardBloc.searchList] state
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: 'Flutter')
  void searchByQuery(String query);

  /// Load the next page of data.
  void loadPage();
}

/// A contract class containing all states of the DashboardBloC.
abstract class DashboardBlocStates {
  /// The loading state of the search and suggestion list
  ConnectableStream<bool> get isLoading;

  /// The error state of the search and suggestion list
  ConnectableStream<ErrorModel> get errors;

  /// The search list state of github repositories that match the search query
  ///
  /// The search list is emitted to the state when the [DashboardBloc.searchByQuery] event is called
  Stream<PaginatedList<GithubRepoModel>> get searchList;

  /// The suggestion list state of github repositories
  ///
  /// The suggestion list is emitted to the state when the [DashboardBloc.fetchSuggestionList] event is called
  ConnectableStream<List<GithubRepoModel>> get suggestionList;
}

@RxBloc()
class DashboardBloc extends $DashboardBloc {
  DashboardBloc(this.dashboardService) {
    suggestionList.connect().addTo(_compositeSubscription);
    isLoading.connect().addTo(_compositeSubscription);
    errors.connect().addTo(_compositeSubscription);

    Rx.merge([
      _$searchByQueryEvent
          .throttleTime(const Duration(milliseconds: 600))
          .distinct()
          .switchMap(_searchBySearchQuery),
      _$loadPageEvent
          .throttleTime(const Duration(milliseconds: 600))
          .switchMap(_fetchNextPage)
    ])
        // Enable state handling by the current bloc
        .setResultStateHandler(this)
        // Merge the data in the _repoList
        .mergeWithPaginatedList(_repoList)
        .bind(_repoList)
        // Make sure we dispose the subscription
        .addTo(_compositeSubscription);
  }

  final DashboardService dashboardService;

  /// Internal paginated list stream
  final _repoList = BehaviorSubject<PaginatedList<GithubRepoModel>>.seeded(
    PaginatedList<GithubRepoModel>(
      list: [],
      pageSize: 50,
    ),
  );

  @override
  ConnectableStream<ErrorModel> _mapToErrorsState() =>
      errorState.mapToErrorModel().publish();

  @override
  ConnectableStream<bool> _mapToIsLoadingState() =>
      loadingState.startWith(false).publishReplay(maxSize: 1);

  @override
  Stream<PaginatedList<GithubRepoModel>> _mapToSearchListState() => _repoList;

  @override
  ConnectableStream<List<GithubRepoModel>> _mapToSuggestionListState() =>
      _$fetchSuggestionListEvent
          .startWith(null)
          .switchMap(
            (query) => dashboardService.fetchSuggestionList().asResultStream(),
          )
          .setResultStateHandler(this)
          .whereSuccess()
          .publishReplay(maxSize: 1);

  Stream<Result<PaginatedList<GithubRepoModel>>> _searchBySearchQuery(
    searchQuery,
  ) {
    _repoList.value.reset(hard: false);

    return dashboardService
        .fetchSearchList(
          searchQuery,
          page: 1,
          pageSize: _repoList.value.pageSize,
        )
        .asResultStream();
  }

  Stream<Result<PaginatedList<GithubRepoModel>>> _fetchNextPage(searchQuery) =>
      dashboardService
          .fetchSearchList(
            _$searchByQueryEvent.value,
            page: _repoList.value.pageNumber + 1,
            pageSize: _repoList.value.pageSize,
          )
          .asResultStream();

  @override
  void dispose() {
    _repoList.close();
    super.dispose();
  }
}
