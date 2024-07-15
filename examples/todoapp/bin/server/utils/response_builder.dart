// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'server_exceptions.dart';
import 'utilities.dart';

/// [ResponseBuilder] is a convenience class that helps you build responses with
/// ease and customize them.
class ResponseBuilder {
  static const _kStatus = 'status';

  Map<String, String> _buildFromDefaultHeader([Map<String, String>? data]) {
    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': '*',
      'Access-Control-Allow-Headers': '*',
      'Access-Control-Allow-Credentials': 'true',
    };
    if (data != null) {
      data.forEach((key, value) => headers.putIfAbsent(key, () => value));
    }

    return headers;
  }

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
    bool includeStatusMessage = false,
  }) =>
      _buildSuccessResponse(200, headers, data, includeStatusMessage);

  /// Builds an error response based on the status code
  Response _buildErrorResponse(
    int statusCode,
    String errorMessage, [
    Request? request,
    Map<String, Object>? headers,
    Map<String, Object>? data,
  ]) {
    final body = <String, Object>{
      if (request != null) 'url': request.requestedUri.toString(),
      _kStatus: getStatusMessage(statusCode),
      'error': errorMessage,
    };
    // Add additional data, if provided
    if (data != null) body.addAll(data);

    return Response(
      statusCode,
      body: const JsonEncoder.withIndent(' ').convert(body),
      headers: headers ??
          _buildFromDefaultHeader({'content-type': 'application/problem+json'}),
    );
  }

  /// Builds an success response based on the status code
  Response _buildSuccessResponse(
    int statusCode, [
    Map<String, Object>? headers,
    Map<String, dynamic>? data,
    bool includeStatusMessage = false,
  ]) {
    assert(statusCode >= 200 && statusCode < 300,
        '$statusCode is not a valid success response code.');

    final body = <String, dynamic>{
      if (includeStatusMessage) _kStatus: getStatusMessage(statusCode),
    };
    // Add additional data, if provided
    if (data != null) body.addAll(data);

    return Response.ok(
      const JsonEncoder.withIndent(' ').convert(body),
      headers: headers ??
          _buildFromDefaultHeader({'content-type': 'application/json'}),
    );
  }
}
