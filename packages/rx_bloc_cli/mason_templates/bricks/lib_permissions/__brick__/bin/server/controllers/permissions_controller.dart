{{> licence.dart }}

import 'package:shelf/shelf.dart';
{{#has_authentication}}
import '../services/authentication_service.dart';{{/has_authentication}}
import '../utils/api_controller.dart';

class PermissionsController extends ApiController {
  PermissionsController({{#has_authentication}}this._authenticationService{{/has_authentication}});{{#has_authentication}}

  final AuthenticationService _authenticationService;{{/has_authentication}}

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/permissions',
      permissionsHandler,
    );
  }

  Response permissionsHandler(Request request) { {{#has_authentication}}
    final headers = request.headers;
    if (!headers.containsKey(AuthenticationService.authHeader)) {
      return responseBuilder.buildOK(data: { {{#enable_feature_auth_matrix}}
        'AuthMatrixRoute': false,{{/enable_feature_auth_matrix}}
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

    _authenticationService.isAuthenticated(request);{{/has_authentication}}

    return responseBuilder.buildOK(data: { {{#enable_feature_auth_matrix}}
      'AuthMatrixRoute': true,{{/enable_feature_auth_matrix}}
      'DashboardRoute': true,
      'ProfileRoute': true,
      'SplashRoute': true,{{#enable_feature_counter}}
      'CounterRoute': true,{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
      'WidgetToolkitRoute': true,{{/enable_feature_widget_toolkit}}
      'NotificationsRoute': true,{{#has_authentication}}
      'LoginRoute': true,{{/has_authentication}}{{#enable_feature_deeplinks}}
      'EnterMessageRoute': true,
      'DeepLinksRoute': true,
      'DeepLinkDetailsRoute': true,{{/enable_feature_deeplinks}}
    });
  }
}
