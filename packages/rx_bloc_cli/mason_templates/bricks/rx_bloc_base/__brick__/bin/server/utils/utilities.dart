{{> licence.dart }}

import 'dart:math';

import 'package:shelf/shelf.dart';

import 'response_builder.dart';
import 'server_exceptions.dart';

final _statusCodeMessages = {
  // 2xx : Success codes
  200: '200 OK',
  201: '201 Created',
  202: '202 Accepted',
  204: '204 No Content',

  // 3xx : Redirection codes
  301: '301 Moved Permanently',

  // 4xx : Client side codes
  400: '400 Bad Request',
  401: '401 Unauthorized',
  403: '403 Forbidden',
  404: '404 Not Found',
  408: '408 Request Timeout',
  415: '415 Unsupported Media Type',
  422: '422 Unprocessable Entity',

  // 5xx : Server side codes
  500: '500 Internal Server Error',
  501: '501 Not Implemented',
  502: '502 Bad Gateway',
  503: '503 Service Unavailable',
  511: '511 Network Authentication Required'
};

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
Random _random = Random();

/// Returns a status message for the given code.
String getStatusMessage(int code) =>
    _statusCodeMessages[code] ?? 'Unknown Error';

/// Builds a wrapper around the callback which helps easily detect and respond
/// to different kinds of errors/exceptions.
Handler buildSafeHandler(Function callback, ResponseBuilder responseBuilder) =>
    (request) async {
      try {
        final response = await callback(request);
        return response;
      } on ResponseException catch (e) {
        return responseBuilder.buildErrorResponse(e, request: request);
      } on Exception catch (e) {
        return responseBuilder.buildUnprocessableEntity(e, request: request);
      }
    };

/// Generates a random string of given length
String generateRandomString([int charsNum = 64]) =>
    String.fromCharCodes(Iterable.generate(
        charsNum, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
