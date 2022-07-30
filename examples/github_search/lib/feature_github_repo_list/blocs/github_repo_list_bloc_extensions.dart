part of 'github_repo_list_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _GithubRepoListExtension on GithubRepoListBloc {}

extension _PaginatedUtilsString on Stream<String> {
  Stream<GithubRepoPaginatedSearch> mapToPaginatedSearch() =>
      debounceTime(const Duration(milliseconds: 600)).map(
        (query) => GithubRepoPaginatedSearch(
          query: query,
          reset: true,
          hardReset: true,
        ),
      );
}

extension _PaginatedUtilsBool on Stream<_LoadPageEventArgs> {
  Stream<GithubRepoPaginatedSearch> mapToPaginatedSearch(
    BehaviorSubject<String> query,
  ) =>
      map(
        (reset) => GithubRepoPaginatedSearch(
          query: query.value,
          reset: reset.reset,
          hardReset: reset.hardReset,
        ),
      );
}

extension GithubRepoListBlocStreamExtensions
    on Stream<GithubRepoPaginatedSearch> {
  /// Fetches appropriate data from the repository
  Stream<Result<PaginatedList<GithubRepo>>> fetchData(
    GithubReposRepository _repository,
    BehaviorSubject<PaginatedList<GithubRepo>> _paginatedList,
  ) =>
      throttleTime(const Duration(milliseconds: 600)).switchMap(
        (search) {
          if (search.reset) _paginatedList.value.reset(hard: search.hardReset);
          return _repository
              .search(
                query: search.query,
                page: _paginatedList.value.pageNumber + 1,
                pageSize: _paginatedList.value.pageSize,
              )
              .asResultStream();
        },
      );

  Stream<GithubRepoPaginatedSearch> startWithDefaults(
    BehaviorSubject<String> query,
  ) =>
      startWith(
        GithubRepoPaginatedSearch(
          query: query.value,
          reset: true,
          hardReset: false,
        ),
      );
}
