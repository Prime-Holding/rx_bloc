import 'package:rx_bloc_list/models.dart';

import '../common_mappers/error_mappers/error_mapper.dart';
import '../data_sources/remote/github_repos_data_source.dart';
import '../models/github_repo_model.dart';

class GithubReposRepository {
  GithubReposRepository(this._dataSource, this._errorMapper);

  final GithubReposDataSource _dataSource;
  final ErrorMapper _errorMapper;

  Future<PaginatedList<GithubRepoModel>> search({
    required int page,
    required String query,
    int pageSize = 30,
  }) =>
      _errorMapper.execute(() async {
        final response = await _dataSource.search(
          query: query,
          page: page,
        );

        return PaginatedList(
          list: response.items,
          totalCount: response.totalCount,
          pageSize: pageSize,
        );
      });
}
