// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AuthDataSource implements AuthDataSource {
  _AuthDataSource(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://0.0.0.0:8080';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AuthTokenModel> authenticate(authData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(authData.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AuthTokenModel>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/api/authenticate',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AuthTokenModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<void> logout() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.fetch<void>(_setStreamType<void>(
        Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
            .compose(_dio.options, '/api/logout',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
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
