part of 'profile_list_bloc.dart';

/// TODO: Here you can add the implementation details of your BloC or any stream extensions you might need.
/// Thus, the BloC will contain only declarations, which improves the readability and the maintainability.
extension _ProfileListExtension on ProfileListBloc {}

/// Utility extensions for the Stream<bool> streams used within ProfileListBloc
extension ProfileListBlocStreamExtensions on Stream<bool> {
  /// Fetches appropriate data from the repository
  Stream<Result<PaginatedList<Profile>>> fetchData(
    ProfileRepository _repository,
    BehaviorSubject<PaginatedList<Profile>> _paginatedList,
  ) =>
      switchMap(
        (reset) {
          if (reset) _paginatedList.value.reset();
          return _repository
              .fetchPage(
                _paginatedList.value.pageNumber + 1,
                _paginatedList.value.pageSize,
              )
              .asResultStream();
        },
      );
}