import 'package:dio/dio.dart';
import 'package:github_search/base/models/response_models/github_repos_reponse.dart';
import 'package:retrofit/retrofit.dart';

part 'github_repos_data_source.g.dart';

@RestApi(baseUrl: 'https://api.github.com/')
abstract class GithubReposDataSource {
  factory GithubReposDataSource(Dio dio, {String baseUrl}) =
      _GithubReposDataSource;

  @GET('/search/repositories')
  Future<GithubReposResponse> search({
    @Query('q') required String query,
    @Query('page') int page = 1,
  });
}
