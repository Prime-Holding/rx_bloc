{{> licence.dart }}

import 'package:shelf/shelf.dart';

import '../utils/api_controller.dart';
import 'authentication_controller.dart';

class PermissionsController extends ApiController {
  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/permissions',
      permissionsHandler,
    );
  }

  Response permissionsHandler(Request request) {
    try {
      controllers
          .getController<AuthenticationController>()
          ?.isAuthenticated(request);
    } catch (exception) {
      return responseBuilder.buildOK(data: {
        'ProfileRoute': false,
        'SplashRoute': true,
        'CounterRouter': false,
        'NotificationsRoute': false,
        'LoginRoute': true,
        'EnterMessageRoute': false,
        'DeepLinksRoute': false,
        'DeepLinkDetailsRoute': false,
      });
    }
    return responseBuilder.buildOK(data: {
      'ProfileRoute': true,
      'SplashRoute': true,
      'CounterRouter': true,
      'NotificationsRoute': true,
      'LoginRoute': false,
      'EnterMessageRoute': true,
      'DeepLinksRoute': true,
      'DeepLinkDetailsRoute': true,
    });
  }
}
