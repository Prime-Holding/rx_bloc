import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/github_repos_reponse.dart';

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
