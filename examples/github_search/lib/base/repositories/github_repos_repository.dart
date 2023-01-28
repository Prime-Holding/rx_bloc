import 'package:rx_bloc_list/models.dart';

import '../data_sources/remote/github_repos_data_source.dart';
import '../models/github_repo.dart';

class GithubReposRepository {
  GithubReposRepository(GithubReposDataSource dataSource)
      : _dataSource = dataSource;

  final GithubReposDataSource _dataSource;

  Future<PaginatedList<GithubRepo>> search({
    required int page,
    required String query,
    int pageSize = 30,
  }) async {
    final response = await _dataSource.search(
      query: query,
      page: page,
    );

    return PaginatedList(
      list: response.items,
      totalCount: response.totalCount,
      pageSize: pageSize,
    );
  }
}
