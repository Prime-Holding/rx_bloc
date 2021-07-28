// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repos_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _GithubReposDataSource implements GithubReposDataSource {
  _GithubReposDataSource(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.github.com/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GithubReposResponse> search({required query, page = 1}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'q': query, r'page': page};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GithubReposResponse>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/search/repositories',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GithubReposResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
