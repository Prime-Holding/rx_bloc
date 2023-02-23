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
        'item': {
          'ProfileRoute': false,
          'SplashRoute': true,
          'CounterRouter': true,
          'NotificationsRoute': false,
          'LoginRoute': true,
          'EnterMessageRoute': false,
          'ItemsRoute': false,
          'ItemDetailsRoute': false,
        }
      });
    }
    return responseBuilder.buildOK(data: {
      'item': {
        'ProfileRoute': true,
        'SplashRoute': true,
        'CounterRouter': true,
        'NotificationsRoute': true,
        'LoginRoute': false,
        'EnterMessageRoute': true,
        'ItemsRoute': true,
        'ItemDetailsRoute': true,
      }
    });
  }
}
