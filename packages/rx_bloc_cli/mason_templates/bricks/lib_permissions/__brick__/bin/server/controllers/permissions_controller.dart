{{> licence.dart }}

import 'package:shelf/shelf.dart';

import '../services/authentication_service.dart';
import '../utils/api_controller.dart';

class PermissionsController extends ApiController {
  PermissionsController(this._authenticationService);

  final AuthenticationService _authenticationService;

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
    if (!headers.containsKey(AuthenticationService.authHeader)) {
      return responseBuilder.buildOK(data: { {{#enable_pin_code}}
        'CreatePinRoute': false,
        'UpdatePinRoute': false,{{/enable_pin_code}}
        'DashboardRoute': false,
        'ProfileRoute': false,
        'SplashRoute': true,{{#enable_feature_counter}}
        'CounterRoute': false,{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
        'WidgetToolkitRoute': true,{{/enable_feature_widget_toolkit}}
        'NotificationsRoute': false,
        'LoginRoute': true,{{#enable_feature_deeplinks}}
        'EnterMessageRoute': false,
        'DeepLinksRoute': false,
        'DeepLinkDetailsRoute': false,{{/enable_feature_deeplinks}}
      });
    }

    _authenticationService.isAuthenticated(request);

    return responseBuilder.buildOK(data: { {{#enable_pin_code}}
      'CreatePinRoute': true,
      'UpdatePinRoute': true,{{/enable_pin_code}}
      'DashboardRoute': true,
      'ProfileRoute': true,
      'SplashRoute': true,{{#enable_feature_counter}}
      'CounterRoute': true,{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
      'WidgetToolkitRoute': true,{{/enable_feature_widget_toolkit}}
      'NotificationsRoute': true,
      'LoginRoute': true,{{#enable_feature_deeplinks}}
      'EnterMessageRoute': true,
      'DeepLinksRoute': true,
      'DeepLinkDetailsRoute': true,{{/enable_feature_deeplinks}}
    });
  }
}
