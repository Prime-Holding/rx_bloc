part of 'github_repo_list_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _GithubRepoListExtension on GithubRepoListBloc {}

/// Utility extensions for the Stream<bool> streams used within GithubRepoListBloc
extension GithubRepoListBlocStreamExtensions on Stream<bool> {
  /// Fetches appropriate data from the repository
  Stream<Result<PaginatedList<GithubRepo>>> fetchData(
    GithubReposRepository _repository,
    BehaviorSubject<PaginatedList<GithubRepo>> _paginatedList,
  ) =>
      throttleTime(const Duration(milliseconds: 600)).switchMap(
        (reset) {
          if (reset) _paginatedList.value.reset();
          return _repository
              .search(
                query: "Flutter",
                page: _paginatedList.value.pageNumber + 1,
                pageSize: _paginatedList.value.pageSize,
              )
              .asResultStream();
        },
      );
}
