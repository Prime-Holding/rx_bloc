{{> licence.dart }}

// ignore_for_file: lines_longer_than_80_chars

import 'utilities.dart';

/// Universal Server exception
class ServerException implements Exception {
  ServerException(this.message);

  final String message;

  @override
  String toString() => 'ServerError: $message';
}

/// Exception thrown instead of a response being returned
class ResponseException extends ServerException {
  ResponseException(this.statusCode, String message)
      : statusMessage = getStatusMessage(statusCode),
        super(message);

  final int statusCode;
  final String statusMessage;

  @override
  String toString() => message;
}

/// region Client error exceptions

/// [BadRequestException] : Error 400 - Bad Request
///
/// The server could not understand the request due to invalid syntax.
class BadRequestException extends ResponseException {
  BadRequestException(String message) : super(400, message);
}

/// [UnauthorizedException] : Error 401 - Unauthorized
///
/// Indicates that the request requires user authentication information.
class UnauthorizedException extends ResponseException {
  UnauthorizedException(String message) : super(401, message);
}

/// [ForbiddenException] : Error 403 - Forbidden
///
/// Unauthorized request. The client does not have access rights to the content.
/// Unlike Error 401, the client’s identity is known to the server.
class ForbiddenException extends ResponseException {
  ForbiddenException(String message) : super(403, message);
}

/// [NotFoundException] : Error 404 - Not found
///
/// The server can not find the requested resource.
class NotFoundException extends ResponseException {
  NotFoundException(String message) : super(404, message);
}

/// [RequestTimeoutException] : Error 408 - Request Timeout
///
/// Indicates that the server did not receive a complete request from the client
/// within the server’s allotted timeout period.
class RequestTimeoutException extends ResponseException {
  RequestTimeoutException(String message) : super(408, message);
}

/// [UnsupportedMediaTypeException] : Error 415 - Request Timeout
///
/// The mediatype in Content-type of the request is not supported by the server.
class UnsupportedMediaTypeException extends ResponseException {
  UnsupportedMediaTypeException(String message) : super(415, message);
}

/// [UnprocessableEntityException] : Error 422 - Unprocessable Entity
///
/// The request was well-formed but was unable to be followed due to semantic errors.
class UnprocessableEntityException extends ResponseException {
  UnprocessableEntityException(String message) : super(422, message);
}

/// endregion

/// region Server error exceptions

/// [InternalServerErrorException] : Error 500 - Internal Server Error
///
/// The server has encountered a situation it doesn't know how to handle.
class InternalServerErrorException extends ResponseException {
  InternalServerErrorException(String message) : super(500, message);
}

/// [NotImplementedException] : Error 501 - Not Implemented
///
/// The request method is not supported by the server and cannot be handled.
class NotImplementedException extends ResponseException {
  NotImplementedException(String message) : super(501, message);
}

/// [BadGatewayException] : Error 502 - Bad Gateway
///
/// The server got an invalid response while working as a gateway to get a
/// response needed to handle the request.
class BadGatewayException extends ResponseException {
  BadGatewayException(String message) : super(502, message);
}

/// [ServiceUnavailableException] : Error 503 - Service Unavailable
///
/// The server is not ready to handle the request.
class ServiceUnavailableException extends ResponseException {
  ServiceUnavailableException(String message) : super(503, message);
}

/// [NetworkAuthenticationRequiredException] : Error 511 - Network Authentication Required
///
/// Indicates that the client needs to authenticate to gain network access.
class NetworkAuthenticationRequiredException extends ResponseException {
  NetworkAuthenticationRequiredException(String message) : super(511, message);
}

/// endregion
