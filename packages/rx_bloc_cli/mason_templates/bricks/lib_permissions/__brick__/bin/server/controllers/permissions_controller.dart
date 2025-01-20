{{> licence.dart }}

import 'package:shelf/shelf.dart';
{{#has_authentication}}
import '../services/authentication_service.dart';{{/has_authentication}}{{#enable_feature_onboarding}}
import '../services/users_service.dart';{{/enable_feature_onboarding}}
import '../utils/api_controller.dart';

class PermissionsController extends ApiController {
  PermissionsController({{#has_authentication}}
    this._authenticationService,{{#enable_feature_onboarding}}
    this._usersService,{{/enable_feature_onboarding}}{{/has_authentication}}
  );{{#has_authentication}}

  final AuthenticationService _authenticationService;{{#enable_feature_onboarding}}
  final UsersService _usersService;{{/enable_feature_onboarding}}{{/has_authentication}}

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
    if (!headers.containsKey(AuthenticationService.authHeader) {{#enable_feature_onboarding}} || _usersService.isTempUser(_authenticationService.getUserIdFromAuthHeader(headers)) {{/enable_feature_onboarding}}) {
      return responseBuilder.buildOK(data: { {{#enable_mfa}}
        'MfaRoute': false,{{/enable_mfa}}{{#enable_pin_code}}
        'CreatePinRoute': false,
        'UpdatePinRoute': false,{{/enable_pin_code}}
        'DashboardRoute': false,{{#enable_profile}}
        'ProfileRoute': false,{{/enable_profile}}
        'SplashRoute': true,{{#enable_feature_counter}}
        'CounterRoute': false,{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
        'WidgetToolkitRoute': true,{{/enable_feature_widget_toolkit}}
        'NotificationsRoute': false,
        'LoginRoute': true,{{#enable_feature_onboarding}}
        'EmailChangeRoute': true,
        'EmailChangeConfirmationRoute': true,
        'EmailChangeConfirmedRoute': true,
        'OnboardingRoute': true,
        'OnboardingEmailConfirmationRoute': true,
        'OnboardingEmailConfirmedRoute': true,
        'OnboardingPhoneRoute' : true,
        'OnboardingPhoneConfirmRoute' : true,{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
        'EnterMessageRoute': false,
        'DeepLinksRoute': false,
        'DeepLinkDetailsRoute': false,{{/enable_feature_deeplinks}}
      });
    }

    _authenticationService.isAuthenticated(request);{{/has_authentication}}

    return responseBuilder.buildOK(data: { {{#enable_mfa}}
      'MfaRoute': true,{{/enable_mfa}}{{#enable_pin_code}}
      'CreatePinRoute': true,
      'UpdatePinRoute': true,{{/enable_pin_code}}
      'DashboardRoute': true,{{#enable_profile}}
      'ProfileRoute': true,{{/enable_profile}}
      'SplashRoute': true,{{#enable_feature_counter}}
      'CounterRoute': true,{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
      'WidgetToolkitRoute': true,{{/enable_feature_widget_toolkit}}
      'NotificationsRoute': true,{{#has_authentication}}
      'LoginRoute': true,{{/has_authentication}}{{#enable_feature_onboarding}}
      'EmailChangeRoute': true,
      'EmailChangeConfirmationRoute': true,
      'EmailChangeConfirmedRoute': true,
      'OnboardingRoute': true,
      'OnboardingEmailConfirmationRoute': true,
      'OnboardingEmailConfirmedRoute': true,
      'OnboardingPhoneRoute' : true,
      'OnboardingPhoneConfirmRoute' : true,{{/enable_feature_onboarding}}{{#enable_feature_deeplinks}}
      'EnterMessageRoute': true,
      'DeepLinksRoute': true,
      'DeepLinkDetailsRoute': true,{{/enable_feature_deeplinks}}
    });
  }
}
