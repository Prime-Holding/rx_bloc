import 'package:rx_bloc_list/models.dart';

import '../../base/models/github_repo_model.dart';
import '../../base/repositories/github_repos_repository.dart';

class DashboardService {
  //Add repository dependencies as needed
  DashboardService(this._githubReposRepository);

  final GithubReposRepository _githubReposRepository;

  /// Fetches a list of suggestions
  ///
  /// Note: Usually this method would fetch data from a remote server via a repository
  Future<List<GithubRepoModel>> fetchSuggestionList() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      GithubRepoModel(
        name: 'rx_bloc',
        description:
            "A Flutter package that helps implementing the BLoC (Business Logic Component) Design Pattern using the power of reactive streams.",
        url:
            'https://github.com/Prime-Holding/rx_bloc/tree/master/packages/rx_bloc',
      ),
      GithubRepoModel(
        name: 'flutter_rx_bloc',
        description:
            "Set of Flutter Widgets that help implementing the BLoC design pattern. Built to be used with the rx_bloc package.",
        url:
            'https://github.com/Prime-Holding/rx_bloc/tree/master/packages/flutter_rx_bloc',
      ),
    ];
  }

  /// Fetches a list of search results
  Future<PaginatedList<GithubRepoModel>> fetchSearchList(
    String query, {
    required int page,
    required int pageSize,
  }) =>
      _githubReposRepository.search(
        page: page,
        query: query,
        pageSize: pageSize,
      );
}
