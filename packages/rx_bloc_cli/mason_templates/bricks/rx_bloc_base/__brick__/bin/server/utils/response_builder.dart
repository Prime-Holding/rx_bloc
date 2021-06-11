import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'server_exceptions.dart';
import 'utilities.dart';

/// [ResponseBuilder] is a convenience class that helps you build responses with
/// ease and customize them.
class ResponseBuilder {
  static const _kStatus = 'status';

  /// Returns an error response based on the ResponseException
  Response buildErrorResponse(
    ResponseException exception, {
    Request? request,
    Map<String, Object>? headers,
    Map<String, Object>? data,
  }) =>
      _buildErrorResponse(
          exception.statusCode, exception.toString(), request, headers, data);

  /// Returns a unprocessable entity error response
  Response buildUnprocessableEntity(
    Exception exception, {
    Request? request,
    Map<String, Object>? headers,
    Map<String, Object>? data,
  }) =>
      _buildErrorResponse(
        422,
        exception.toString().replaceAll('Exception: ', ''),
        request,
        headers,
        data,
      );

  /// Returns a universal success response
  Response buildOK({
    Map<String, dynamic>? data,
    Map<String, Object>? headers,
  }) =>
      _buildSuccessResponse(200, headers, data);

  /// Builds an error response based on the status code
  Response _buildErrorResponse(
    int statusCode,
    String errorMessage, [
    Request? request,
    Map<String, Object>? headers,
    Map<String, Object>? data,
  ]) {
    final _body = <String, Object>{
      if (request != null) 'url': request.requestedUri.toString(),
      _kStatus: getStatusMessage(statusCode),
      'error': errorMessage,
    };
    // Add additional data, if provided
    if (data != null) _body.addAll(data);

    return Response(
      statusCode,
      body: const JsonEncoder.withIndent(' ').convert(_body),
      headers: headers ?? {'content-type': 'application/problem+json'},
    );
  }

  /// Builds an success response based on the status code
  Response _buildSuccessResponse(
    int statusCode, [
    Map<String, Object>? headers,
    Map<String, dynamic>? data,
  ]) {
    assert(statusCode >= 200 && statusCode < 300,
        '$statusCode is not a valid success response code.');

    final _body = <String, dynamic>{
      _kStatus: getStatusMessage(statusCode),
    };
    // Add additional data, if provided
    if (data != null) _body.addAll(data);

    return Response(
      statusCode,
      body: const JsonEncoder.withIndent(' ').convert(_body),
      headers: headers ?? {'content-type': 'application/problem+json'},
    );
  }
}
