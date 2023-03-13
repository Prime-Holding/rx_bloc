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
    final headers = request.headers;
    if (!headers.containsKey(AuthenticationController.authHeader)) {
      return responseBuilder.buildOK(data: {
        'DashboardRoute': false,
        'ProfileRoute': false,
        'SplashRoute': true,
        {{#enable_feature_counter}}
        'CounterRouter': false,
        {{/enable_feature_counter}}
        'NotificationsRoute': false,
        'LoginRoute': true,
        {{#enable_feature_deeplinks}}
        'EnterMessageRoute': false,
        'DeepLinksRoute': false,
        'DeepLinkDetailsRoute': false,
        {{/enable_feature_deeplinks}}
      });
    }

    controllers
        .getController<AuthenticationController>()
        ?.isAuthenticated(request);

    return responseBuilder.buildOK(data: {
      'DashboardRoute': true,
      'ProfileRoute': true,
      'SplashRoute': true,
      {{#enable_feature_counter}}
      'CounterRouter': true,
      {{/enable_feature_counter}}
      'NotificationsRoute': true,
      'LoginRoute': true,
      {{#enable_feature_deeplinks}}
      'EnterMessageRoute': true,
      'DeepLinksRoute': true,
      'DeepLinkDetailsRoute': true,
      {{/enable_feature_deeplinks}}
    });
  }
}
