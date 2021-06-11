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

/// Returns a status message for given code
String getStatusMessage(int code) {
  final msg = _statusCodeMessages[code];
  return msg ?? 'Unknown Error';
}
