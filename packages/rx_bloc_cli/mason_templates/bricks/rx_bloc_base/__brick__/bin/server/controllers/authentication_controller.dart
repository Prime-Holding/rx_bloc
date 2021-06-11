import 'package:shelf/shelf.dart';

import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class AuthenticationController extends ApiController {
  @override
  void registerRequests() {
    addRequest(RequestType.POST, '/api/authenticate', authenticationHandler);
    addRequest(RequestType.POST, '/api/logout', logoutHandler);
  }

  Response authenticationHandler(Request request) {
    final params = request.url.queryParameters;
    if (params['username']?.isEmpty ?? true) {
      throw BadRequestException('The username cannot be empty.');
    }
    if (params['password']?.isEmpty ?? true) {
      throw BadRequestException('The password cannot be empty.');
    }

    // Add authentication logic

    return responseBuilder.buildOK();
  }

  Response logoutHandler(Request request) {
    print('Logging out!');
    return responseBuilder.buildOK();
  }
}
