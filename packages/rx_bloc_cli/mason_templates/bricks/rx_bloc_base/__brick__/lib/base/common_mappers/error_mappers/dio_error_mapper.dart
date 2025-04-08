part of 'error_mapper.dart';

extension _DioErrorMapper on DioException {
  static const String kConnectionRefusedError = 'Connection refused';
  ErrorModel asErrorModel() {
    {{#analytics}}
    final errorLogDetails = _mapToErrorLogDetails(); // TODO: Handle details
    {{/analytics}}
    if (type == DioExceptionType.badResponse && response != null) {
      if (response!.statusCode == 500) {
        try {
          // TODO: create error model from response
        } catch (e) {
          return ServerErrorModel({{#analytics}}errorLogDetails{{/analytics}});
        }
      }

      if (response!.statusCode == 400) {
        return BadRequestErrorModel(
          message: response!.mapToString(),
          {{#analytics}}errorLogDetails: errorLogDetails,{{/analytics}}
        );
      }

      if (response!.statusCode == 403) {
        return AccessDeniedErrorModel({{#analytics}}errorLogDetails{{/analytics}});
      }

      if (response!.statusCode == 404) {
        return NotFoundErrorModel(
          message: response!.mapToString(),
          {{#analytics}}errorLogDetails: errorLogDetails,{{/analytics}}
        );
      }

      if (response!.statusCode == 409) {
        return ConflictErrorModel(
          message: response!.mapToString(),
          {{#analytics}}errorLogDetails: errorLogDetails,{{/analytics}}
        );
      }

      if (response!.statusCode == 422) {
        return ErrorServerGenericModel(
          message: response!.mapToString(),
          {{#analytics}}errorLogDetails: errorLogDetails,{{/analytics}}
        );
      }

      if (response!.statusCode == 429) {
        return ErrorTimeoutModel(
          message: response!.mapToString(),
          {{#analytics}}errorLogDetails: errorLogDetails,{{/analytics}}
        );
      }
    }

    if (type == DioExceptionType.unknown && error is SocketException) {
      final errorCode = (error as SocketException).osError?.errorCode;
      if (errorCode == 101) {
        return NoConnectionErrorModel({{#analytics}}errorLogDetails{{/analytics}});
      }
      final errorMessage = (error as SocketException).osError?.message ?? '';
      if (errorMessage.contains(kConnectionRefusedError)) {
        return ConnectionRefusedErrorModel({{#analytics}}errorLogDetails{{/analytics}});
      }
    }

    return NetworkErrorModel({{#analytics}}errorLogDetails{{/analytics}});
  }

  {{#analytics}}
  Map<String, String> _mapToErrorLogDetails() {
    final endpoint = '${requestOptions.baseUrl}${requestOptions.path}';

    //request headers
    final contentType =
        requestOptions.headers[HttpHeaders.contentTypeHeader] ?? '';

    //response headers
    final responseContentType =
        response?.headers[HttpHeaders.contentTypeHeader] ?? '';

    final responseBody = response?.data ?? '';
    final statusCode = response?.statusCode.toString() ?? '';

    final Map<String, dynamic> requestHeaders = {
      'content-type': contentType,
    };
    final Map<String, dynamic> responseHeaders = {
      'content-type': responseContentType,
    };

    return {
      kErrorLogEndpoint: endpoint,
      kErrorLogStatusCode: statusCode,
      kErrorLogRequestHeaders: requestHeaders.toString(),
      kErrorLogResponseHeaders: responseHeaders.toString(),
      kErrorLogResponseBody: responseBody.toString(),
    };
  }
  {{/analytics}}
}
